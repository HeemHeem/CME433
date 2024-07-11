
/* kernel.cl 
 * Matrix multiplication
 * Device code.
 * Check out vectorAdd.cl as an example...
 */
 
// OpenCL Kernel
// Len_B == columns of matrix B and also the same as the column of matrix C
__kernel void matrixMul(__global float* C, __global float* A, __global float* B, int Len_A, int Len_B)
{
	int tx = get_global_id(0);
    int ty = get_global_id(1);
	//each element is computed by one thread
	float sum = 0;

	for(int i = 0; i < Len_A; i++)
	{	
		float elemA = A[ty*Len_A + i];
		float elemB = B[i*Len_B + tx];
		sum += elemA * elemB;
	}

	C[ty*Len_A + tx] = sum;
}
