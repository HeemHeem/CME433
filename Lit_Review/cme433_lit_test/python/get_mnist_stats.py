import gzip
import sys
import numpy as np


def twoscomp_to_decimal(inarray, bits_in_word):
    inputs = []
    for bin_input in inarray:
        if bin_input[0] == "0":
            inputs.append(int(bin_input, 2))
        else:
            inputs.append(int(bin_input, 2) - (1 << bits_in_word))
    inputs = np.array(inputs)
    return inputs

test_y = None
with open("../data/t10k-labels-idx1-ubyte.gz", "rb") as f:
    data = f.read()
    test_y = np.frombuffer(gzip.decompress(data), dtype=np.uint8).copy()

test_y = test_y[8:]

# print(sys.argv)

SVERILOG_BATCH_COUNT = 100
SVERILOG_BATCH_SIZE = 1
ROOT_DIR = "../results/"
SVERILOG_FINAL_LAYER = 2
VERSION = sys.argv[1]
MAX_VAL = 16129 # 127*127 because 2^7 * 2^7 for the highest value

acc = 0
for i in range(0, SVERILOG_BATCH_COUNT):
    predictions_bin = []
    with open(
        ROOT_DIR
        + "mult{}_{}in_layer{}_out.txt".format(VERSION, i, SVERILOG_FINAL_LAYER)
    ) as pfile:
        predictions_bin = pfile.readlines()

    predictions = twoscomp_to_decimal(predictions_bin, 8)

    if predictions.argmax() == test_y[i]:
        acc += 1
 
print("Acc: ", acc  * 100/ SVERILOG_BATCH_COUNT)


"""
Calculate Normalized Mean Error Distance (NMED) for the layers given
and last layer
"""
def nmed_layer(layer):
    count = 0
    EMAC = 0
    NMED = 0

    for i in range(0, SVERILOG_BATCH_COUNT):
        predictions_bin_exact = []
        predictions_bin_approx = []
        predictions_exact = []
        predictions_approx = []
        EXACT = "exact"
        with open(
            ROOT_DIR
            + "mult{}_{}in_layer{}_out.txt".format(EXACT, i, layer)
        ) as pfile:
            predictions_bin_exact = pfile.readlines()

        predictions_exact = twoscomp_to_decimal(predictions_bin_exact, 8)

        with open(
            ROOT_DIR
            + "mult{}_{}in_layer{}_out.txt".format(VERSION, i, layer)
        ) as pfile:
            predictions_bin_approx = pfile.readlines()

        predictions_approx = twoscomp_to_decimal(predictions_bin_approx,8)

        for i in range(0, len(predictions_exact)):
            EMAC += abs(predictions_approx[i]-predictions_exact[i])
            count += 1
    mean_EMAC = (EMAC/count)
    NMED = mean_EMAC/MAX_VAL

        
    return NMED

# calculate the NMED for each layer

if (VERSION != "approx_lastlayer"):
    nmed0 = nmed_layer(0)
    nmed1 = nmed_layer(1)
    nmed2 = nmed_layer(2)
    print("NMED Layer 0: ", nmed0)
    print("NMED Layer 1: ", nmed1)
    print("NMED Layer 2: ", nmed2)


if(VERSION == "approx_lastlayer"):
    nmed_last = nmed_layer(2)
    print("NMED Last Layer: ", nmed_last)

# import gzip
# import sys
# import numpy as np

# SVERILOG_BATCH_COUNT = 100
# SVERILOG_BATCH_SIZE = 1
# ROOT_DIR = "../results/"
# SVERILOG_FIRST_LAYER = 0
# SVERILOG_SECOND_LAYER = 1
# SVERILOG_FINAL_LAYER = 2
# MAX_VALUE = 16129 # 127 * 127
# VERSION = sys.argv[1]

# def twoscomp_to_decimal(inarray, bits_in_word):
#     inputs = []
#     for bin_input in inarray:
#         if bin_input[0] == "0":
#             inputs.append(int(bin_input, 2))
#         else:
#             inputs.append(int(bin_input, 2) - (1 << bits_in_word))
#     inputs = np.array(inputs)
#     return inputs

# test_y = None
# with open("../data/t10k-labels-idx1-ubyte.gz", "rb") as f:
#     data = f.read()
#     test_y = np.frombuffer(gzip.decompress(data), dtype=np.uint8).copy()

# test_y = test_y[8:]

# acc = 0
# for i in range(0, SVERILOG_BATCH_COUNT):
#     predictions_bin = []
#     with open(
#         ROOT_DIR
#         + "mult{}_{}in_layer{}_out.txt".format(VERSION, i, SVERILOG_FINAL_LAYER)
#     ) as pfile:
#         predictions_bin = pfile.readlines()

#     predictions = twoscomp_to_decimal(predictions_bin, 8)

#     if predictions.argmax() == test_y[i]:
#         acc += 1

# print("Acc: ", acc * 100 / SVERILOG_BATCH_COUNT)

# """
#     Calculate the Normalized Mean Error Distance (NMED) for the layers provided.
    
#     Args:
#         layer: Specify the layer number for 3x3 Convolutional layers of DNN

#     Returns:
#         Normalied Mean Error Distance (nmed)
# """
# def calculate_nmed_layer(layer):
#     count = 0
#     EMAC = 0
#     NMED = 0
    
#     for i in range(0, SVERILOG_BATCH_COUNT):
#         VERSION1 = "exact"
#         predictions_bin = []
#         with open(
#             ROOT_DIR
#             + "mult{}_{}in_layer{}_out.txt".format(VERSION1, i, layer)
#         ) as pfile:
#             predictions_bin = pfile.readlines()

#         predictions_exact = twoscomp_to_decimal(predictions_bin, 8)

#         # VERSION = "approx_lastlayer"
#         predictions_bin2 = []
#         with open(
#             ROOT_DIR
#             + "mult{}_{}in_layer{}_out.txt".format(VERSION, i, layer)
#         ) as pfile:
#             predictions_bin2 = pfile.readlines()

#         predictions_approx = twoscomp_to_decimal(predictions_bin2, 8)

#         for i in range(0, len(predictions_exact)):
#             EMAC += abs(predictions_approx[i] - predictions_exact[i])
#             count += 1

#     mean_abs_difference = (EMAC / count)
#     #print("MAD: ", mean_abs_difference)
#     NMED = mean_abs_difference / (MAX_VALUE)
#     return NMED

# # Calculate and print NMED of each layer.
# if VERSION != "approx_lastlayer":
#     nmed1 = calculate_nmed_layer(0)
#     nmed2 = calculate_nmed_layer(1)
#     nmed3 = calculate_nmed_layer(2)
#     print("NMED Layer 1: ", nmed1)
#     print("NMED Layer 2: ", nmed2)
#     print("NMED Layer 3: ", nmed3)
# elif VERSION == "approx_lastlayer":
#     nmed3 = calculate_nmed_layer(2)
#     print("NMED Last Layer: ", nmed3)
# else:
#     print("Error - Please input correct arg[1] to calculate NMED")