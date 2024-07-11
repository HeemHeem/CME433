/*************************************/
/* Matrix Multiplication OpenCL code */
/* matrixC = matrixA x matrixB       */
/* Nov 26, 2016                      */
/* Chandler Janzen
/*************************************/

// I recommend you make reference to vectorAdd.c (provided).

//I'm old. I have old code. This gets rid of warnings about me being old.
#define CL_USE_DEPRECATED_OPENCL_1_2_APIS

//system include
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#ifdef __APPLE__
#include <OpenCL/opencl.h>
#else
#include <CL/cl.h>
#endif

//define constant
//  WA: width of matrix A
//  HA: height of matrix A
#define WA 4096
#define HA 4096
#define WB WA
#define HB HA
#define WC WB
#define HC HA

#define MAX_SOURCE_SIZE (0x100000)

//This DEBUG symbol can be useful for troubleshooting
//#define DEBUG 1

//If you are clever, you'd pass matrix size as a parameter...
int main(int argc, char** argv)
{
    //error code returned from api calls
    int err;

    //compute device id
    cl_device_id device_id;
    //compute context
    cl_context context;
    //compute command queue
    cl_command_queue commands;
    //compute program
    cl_program program;
    //compute kernel
    cl_kernel kernel;
    //compute event
    cl_event event;

    //device memory for matrices
    cl_mem d_A;
    cl_mem d_B;
    cl_mem d_C;

    //host memory for vectors
    float *h_A;
	float *h_B;
	float *h_C;

    //allocate host memory for vectorA, vectorB, and vectorC
	h_A = (float*)malloc(sizeof(float) * WA*HA);
	h_B = (float*)malloc(sizeof(float) * WB*HB);
	h_C = (float*)malloc(sizeof(float) * WC*HC);




    //put random value into Matrix A and Matrix B
#ifndef DEBUG
    int seed;
    seed = 256; //Should Randomize this at some point...
    srand(seed);
#endif
    int i;
    for (i = 0; i < WA * HA; i++)
    {
#ifdef DEBUG
        h_A[i] = rand() % 2000;
#else
        h_A[i] = rand();
#endif
    }
    for (i = 0; i < WA * HA; i++)
    {
#ifdef DEBUG
        h_B[i] = rand() % 2000;
#else
        h_B[i] = rand();
#endif
    }

    //initialize OpenCL device
    printf("Initializing OpenCL device...\n");

    //get platform ID
    cl_uint dev_cnt = 0;
	clGetPlatformIDs(0, 0, &dev_cnt); //get the number of devices
	cl_platform_id platform_ids[dev_cnt]; //allocate for them
	clGetPlatformIDs(dev_cnt, platform_ids, NULL); //get their IDs




    //choose a compute device
	//change the platform_ids[] index according to deviceQuery
	//For this lab, we want the (intel) GPU...
	//OpenCL can run on any device (such as a CPU) - execute the kernel on a
	//different thread from the host program.
	int gpu = 1;
	err = clGetDeviceIDs(platform_ids[0], gpu? CL_DEVICE_TYPE_GPU : CL_DEVICE_TYPE_CPU, 1, &device_id, NULL);
	if (err != CL_SUCCESS){
		printf("Error: Failed to create a device group!\n");
		return EXIT_FAILURE;
	}

    //print Device Information
	char* value;
	size_t valueSize;
	clGetDeviceInfo(device_id, CL_DEVICE_NAME, 0, NULL, &valueSize);
	value = (char*)malloc(valueSize);
	clGetDeviceInfo(device_id, CL_DEVICE_NAME, valueSize, value, NULL);
	printf("Device: %s\n", value);
	free(value);




    //create a compute context
	//contexts are used during runtime to manage objects such as command queues, memory,
	//program, and kernel objects.
	//This 'context' object will be populated in various calls below (such as clCreateCommandQueue)
	//You can think of this as the GPU 'object'
	context = clCreateContext(0, 1, &device_id, NULL, NULL, &err);
	if (!context){
		printf("Error: Failed to create a compute context!\n");
		return EXIT_FAILURE;
	}



    //create a command commands
    //NOTE: This is deprecated and should be updated to clCreateCommandQueueWithProperties
	//This call will setup the command queue with associated properties. The command queue gets
	//populated by the GPU based upon the program and options we set below..
	//cl_queue_properties props[] = {CL_QUEUE_PROPERTIES, CL_QUEUE_PROFILING_ENABLE,0}; //for use with host queue
        //cl_queue_properties props[] = {CL_QUEUE_PROPERTIES, CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE | CL_QUEUE_ON_DEVICE | CL_QUEUE_ON_DEVICE_DEFAULT, 0}; //for use with device queue
	//commands = clCreateCommandQueueWithProperties(context, device_id,props, &err);
	commands = clCreateCommandQueue(context, device_id, CL_QUEUE_PROFILING_ENABLE, &err);
	if (!commands){
		printf("Error: Failed to create a command queue!\n");
		return EXIT_FAILURE;
	}




    //create the compute program from the source file
    //read the source file
	FILE *fp;
	const char fileName[] = "./matrixmul_kernel.cl";
	size_t kernel_size;
	char *KernelSource;

	fp = fopen(fileName, "r");
	if (!fp){
		fprintf(stderr, "Failed to load kernel.\n");
		exit(1);
	}
	KernelSource = (char*)malloc(MAX_SOURCE_SIZE);
	kernel_size = fread(KernelSource, 1, MAX_SOURCE_SIZE, fp);
	fclose(fp);





    //create program
	program = clCreateProgramWithSource(context, 1, (const char **)&KernelSource, (const size_t *)&kernel_size, &err);
	if (!program){
		printf("Error: Failed to create compute program!\n");
		return EXIT_FAILURE;
	}




    //build the program executable
	err = clBuildProgram(program, 1, &device_id, NULL, NULL, NULL);
	if (err != CL_SUCCESS){
		size_t len;
		char buffer[2048];
		printf("Error: Failed to build program executable!\n");
		clGetProgramBuildInfo(program, device_id, CL_PROGRAM_BUILD_LOG, sizeof(buffer), buffer, &len);
		printf("%s\n", buffer);
		exit(1);
	}




    //create compute kernel
	kernel = clCreateKernel(program, "matrixMul", &err);
	if (!kernel || err != CL_SUCCESS){
		printf("Error: Failed to create compute kernel!\n");
		exit(1);
	}





    //create the input and output arrays in device memory
	d_C = clCreateBuffer(context, CL_MEM_READ_WRITE, sizeof(float)*WC*HC, NULL, &err);
	d_A = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR, sizeof(float)*WA*HA, h_A, &err);
	d_B = clCreateBuffer(context, CL_MEM_READ_WRITE | CL_MEM_COPY_HOST_PTR, sizeof(float)*WB*HB, h_B, &err);
	if (!d_A || !d_B || !d_C){
		printf("Error: Failed to allocate device memory!\n");
		exit(1);
	}

    printf("Running matrix multiplication for matrices A (%dx%d) and B (%dx%d) ...\n", HA,WA,HB,WB);
    //Pass in our arguments to our GPU function, and a vector to store the results.
	int Len_A = WA;
	int Len_C = WC;
	err = clSetKernelArg(kernel, 0, sizeof(cl_mem), (void*)&d_C);
	err |= clSetKernelArg(kernel, 1, sizeof(cl_mem), (void*)&d_A);
	err |= clSetKernelArg(kernel, 2, sizeof(cl_mem), (void*)&d_B);
	err |= clSetKernelArg(kernel, 3, sizeof(int), (void*)&Len_A);
	err |= clSetKernelArg(kernel, 4, sizeof(int), (void*)&Len_C);
	if (err != CL_SUCCESS){
		printf("Error: Failed to set kernel arguments! %d\n", err);
		exit(1);
	}

    //define global and local work size
	//define global and local work size - The helps the GPU determine how to parallelize the problem.
	//global size can be as big as you want, but must be a multiple of the local size (for each dimension)
	//local size needs to follow some rules based on our current hardware.
	//  - each dimension has a maximum
	//  - limited amount of dimensions
	//  - cumulative workgroup size limitation (product of all dimensions)
	//Each Workgroup runs on a compute unit, and each compute unit can handle multiple workgroups.
  	// global size defines the number of elements (number of work groups).
	// local size defines the size of each element (number of work items).
	// the group ID size is defined by global size / local size for each dimension.
  	// NOTEs: in your CL program, you can access group ID, local ID and global ID.
	// -it is optimal to choose local size to be a multiple of 32/64/128 (changes by manufacturer)
  	// -intel: benefits workgroup size to be a multiple of 8 (vectorization), optimum between 64 and 256
	// -larger workgroups have less overhead, more workgroups have better parrallelization
	//In a Nutshell: Make sure there are enough workgroups to keep the multiple cores busy, and workgroup size large to avoid overhead deficiencies.
	size_t localWorkSize; //globalWorkSize[2];
	localWorkSize = 1;
	size_t globalWorkSize[2] = {WC,HC};

    //launch OpenCL kernel
  	// NOTE: Choosing NULL for the local Work Size allows OpenCL to Automatically determine local workgroup sizes.
  	// This is not always optimal...
	err = clEnqueueNDRangeKernel(commands, kernel, 2, NULL, globalWorkSize, NULL, 0, NULL, &event);


    //executing the kernel 
    //Hint: remember to set the dimension correctly...



    //calculate the execution time
	clFinish(commands); 
	clWaitForEvents(1, &event);
	cl_ulong time_start, time_end;
	double total_time;

	//OpenCL will keep track of this information for us. 
	clGetEventProfilingInfo(event, CL_PROFILING_COMMAND_START, sizeof(time_start), &time_start, NULL);
	clGetEventProfilingInfo(event, CL_PROFILING_COMMAND_END, sizeof(time_end), &time_end, NULL);

	total_time = time_end - time_start;

	if (err != CL_SUCCESS){
		printf("Error: Failed to execute kernel! %d\n", err);
		exit(1);
	}

    //retrieve result from device
	//could also add some sort of check for correctness here...
	err = clEnqueueReadBuffer(commands, d_C, CL_TRUE, 0, sizeof(float)*WC*HC, h_C, 0, NULL, NULL);
	if (err != CL_SUCCESS){
		printf("Error: Failed to read output array! %d\n", err);
		exit(1);
	}





    printf("Matrix multiplication completed...\n");

    //original time in nanosecond
    printf("\nExecution time in milliseconds = %0.3f ms\n", (total_time / 1000000.0));

#ifdef DEBUG
    //output matrix
    printf("matrixA = ");
    for (i = 0; i < WA * HA; i++)
    {
        if (i % WA == 0)
        {
            printf("\n");
        }
        printf("%.0f\t", h_A[i]);
    }
   printf("\n\n");

   printf("matrixB = ");
    for (i = 0; i < WB * HB; i++)
    {
        if (i % WB == 0)
        {
            printf("\n");
        }
        printf("%.0f\t", h_B[i]);
    }
   printf("\n\n");

   printf("matrixC = ");
    for (i = 0; i < WC * HC; i++)
    {
        if (i % WC == 0)
        {
            printf("\n");
        }
        printf("%.0f\t", h_C[i]);
    }
   printf("\n\n");
#endif

    //cleanup host and device

    




    return 0;
}
