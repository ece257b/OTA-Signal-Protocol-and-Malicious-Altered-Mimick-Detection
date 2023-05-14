import os
import json
import pprint 
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.metrics import confusion_matrix
from sklearn.preprocessing import normalize

def plot_quantities(master_dict):
    pass

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
    sns.heatmap(confusion_matrix_df, annot=True, fmt=".2f", cmap='Blues',linewidths=0.5, linecolor='black',cbar = False)
    plt.title('Normalized Confusion Matrix')
    plt.xlabel('Predicted Label')
    plt.ylabel('True Label')
    plt.tight_layout()
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
    top_folder = '/mnt/ext_hdd_18tb/rmathuria/analysis_jsons/'
    master_dict = create_master_dict(top_folder)
    get_confusion_matrix(master_dict)

    