import os
import json
import pprint 
import math
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.metrics import confusion_matrix
from sklearn.preprocessing import normalize
from scipy.interpolate import interp1d

def plot_quantities(master_dict, metric):

    for modulation, data_list in master_dict.items():
        param_accuracy = {}
        for data in data_list:
            param = data[metric]
            param = round(param / 3) * 3
            if param>65:
                continue
            ground_truth = data['truth']
            prediction = data['prediction']
            accuracy = 1 if ground_truth == prediction else 0
            param_accuracy.setdefault(param, []).append(accuracy)

        param_values = []
        accuracies = []
            
        for param, accuracy_list in param_accuracy.items():           
                param_values.append(param)
                accuracies.append(sum(accuracy_list) / len(accuracy_list))

        param_values, accuracies = zip(*sorted(zip(param_values, accuracies)))
        title = f"Accuracy per {metric} for {modulation}"
        plt.plot(param_values, accuracies, marker='o', label=str(param),linewidth=3)
        plt.title(title,fontdict={"fontsize":16})
        plt.xlabel(metric,fontdict={"fontsize":16})
        plt.ylabel('Accuracy',fontdict={"fontsize":16})
        plt.grid(True)
        plt.tick_params(axis='both', which='both', direction='in')  # Set tick direction
        plt.rcParams.update({'font.size': 16})  # Modify font size
        plt.rcParams['font.family'] = 'serif'  # Set font family
        plt.rcParams['font.serif'] = ['Times New Roman']  # Set serif font
        plt.show()

def plot_channel_trends(master_dict, metric):

    for modulation, data_list in master_dict.items():
        param_accuracy = {}
        for data in data_list:
            param = data[metric]
            ground_truth = data['truth']
            prediction = data['prediction']
            accuracy = 1 if ground_truth == prediction else 0
            param_accuracy.setdefault(param, []).append(accuracy)

        param_values = []
        accuracies = []
            
        for param, accuracy_list in param_accuracy.items():           
                param_values.append(param)
                accuracies.append(sum(accuracy_list) / len(accuracy_list))

        param_values, accuracies = zip(*sorted(zip(param_values, accuracies)))
        title = f"Accuracy vs {metric} for {modulation}"
        plt.bar(['Identity', 'Rician', 'Multipath'], accuracies)
        plt.title(title)
        plt.xlabel('Channel type')
        plt.ylabel('Accuracy')
        plt.grid(True)
        plt.tick_params(axis='both', which='both', direction='in')  # Set tick direction
        plt.rcParams.update({'font.size': 12})  # Modify font size
        plt.rcParams['font.family'] = 'serif'  # Set font family
        plt.rcParams['font.serif'] = ['Times New Roman']  # Set serif font
        plt.show()

def plot_overall_quantities(master_dict, metric):
    param_accuracy = {}
    param_values = []
    accuracies = []
    for modulation, data_list in master_dict.items():
        for data in data_list:
            param = data[metric]
            param = round(param / 4) *4
            if param>65:
                continue
            ground_truth = data['truth']
            prediction = data['prediction']
            accuracy = 1 if ground_truth == prediction else 0
            param_accuracy.setdefault(param, []).append(accuracy)
     
    for param, accuracy_list in param_accuracy.items():           
            param_values.append(param)
            accuracies.append(sum(accuracy_list) / len(accuracy_list))

    font = {'family': 'serif',
        'serif': ['Times New Roman'],
        'size': 16}

    # Set the font as the default font for matplotlib
    plt.rc('font', **font)

    param_values, accuracies = zip(*sorted(zip(param_values, accuracies)))
    title = f"Overall Accuracy vs {metric}"
    plt.title(title)
    plt.plot(param_values, np.sort(accuracies), marker='o', label=str(param),linewidth=4)
    plt.title(title,fontsize=18)
    plt.ylabel('Accuracy',fontsize=16)
    plt.xlabel(metric + ' (in dB)',fontdict={"fontsize":16})
    plt.grid(True)
    plt.tick_params(axis='both', which='both', direction='in')  # Set tick direction
    plt.rcParams.update({'font.size': 16})  # Modify font size
    # plt.rcParams['font.family'] = 'serif'  # Set font family
    # plt.rcParams['font.serif'] = ['Times New Roman']  # Set serif font
    plt.show()
      
def data_per_class(master_dict):
    data_count = {}
    for modulations in master_dict.keys():
         data_count[modulations] = len(master_dict[modulations])
    return data_count
         
def get_confusion_matrix(master_dict):
    ground_truth_labels = []
    predicted_labels = []

    for ground_truth, prediction_list in master_dict.items():
        for prediction_dict in prediction_list:
            ground_truth_labels.append(ground_truth)
            predicted_labels.append(prediction_dict['prediction'])

    labels = np.unique(ground_truth_labels + predicted_labels)
    cm = confusion_matrix(ground_truth_labels, predicted_labels)

    normalized_cm = normalize(cm, norm='l1')
    confusion_matrix_df = pd.DataFrame(normalized_cm, index=labels, columns=labels)

    plt.figure(figsize=(10, 8))
    sns.heatmap(confusion_matrix_df, annot=True, fmt=".2f", cmap='Blues',linewidths=0.5, linecolor='black',cbar = False,annot_kws={"size":14})
    plt.subplots_adjust(left=0.4, bottom=0.4)
    ax = plt.gca()
    ax.set_yticklabels(ax.get_yticklabels(), fontsize=16, rotation=45)
    ax.set_xticklabels(ax.get_xticklabels(), fontsize=16, rotation=45)
    plt.xlabel('Predicted Label',fontdict={"fontsize":16,
                                        "fontweight":'bold'})
    plt.ylabel('True Label',fontdict={"fontsize":16,"fontweight":'bold'})
    plt.tight_layout()
    plt.show()

def plot_sym_rate(master_dict):
    param = []
    accuracy = []
    for modulation, data_list in master_dict.items():
        for data in data_list:
            ground_truth = data['truth']
            prediction = data['prediction']
            if ground_truth == prediction:
                param.append(data['trueSymRate'])  
                dat = data['symRate']* (10**-6)            
                accuracy.append(dat)
    # fig, ax = plt.subplots()
    plt.scatter(param,accuracy)
    plt.grid()
    plt.xlabel('True Symbol Rate',fontdict={"fontsize":14})
    plt.ylabel('Estimated Symbol Rate',fontdict={"fontsize":14})
    plt.tight_layout()
    plt.plot(param,param)
    plt.show()
 

    plt.show()
def create_master_dict(top_folder):
    master_dict = {}
    for root, dirs, files in os.walk(top_folder):
        for file in files:
                json_path = os.path.join(root, file)

                try:
                    with open(json_path, 'r') as f:
                        json_data = json.load(f)

                        ground_truth = json_data['truth']
                        prediction_dict = json_data
                       
                        if ground_truth in master_dict:
                            master_dict[ground_truth].append(prediction_dict)
                        else:
                            master_dict[ground_truth] = [prediction_dict]

                except Exception as e:
                    print(f"An error occurred while processing the JSON file: {json_path}")
                    print(f"Error details: {e}")

    return master_dict

if __name__ == '__main__':
    top_folder = '/mnt/ext_hdd18tb/rmathuria/modulation/simulated/analysis_jsons_dummy_searchlight/'
    master_dict = create_master_dict(top_folder)
    # plot_sym_rate(master_dict)
    # get_confusion_matrix(master_dict)
    # plot_channel_trends(master_dict,'channel')
    plot_quantities(master_dict, 'ENR')
    # plot_overall_quantities(master_dict, 'SNR')
    

    