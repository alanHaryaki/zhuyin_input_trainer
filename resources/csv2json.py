import csv
import json

def csv_to_json(csv_file_path, json_file_path):

    data: dict = {}
    # Read the CSV and add the data to a dictionary
    with open(csv_file_path, mode='r', encoding='utf-8-sig') as csv_file:
        csv_reader = csv.DictReader(csv_file)
        for row in csv_reader:
            print(row)
            zhuyin: list = [row["zhuyin"]]
            if row["alt_zhuyin1"]:
                zhuyin.append(row["alt_zhuyin1"])
            data[row["char"]] = zhuyin
            
    # Write the dictionary to a JSON file
    with open(json_file_path, mode='w', encoding='utf-8-sig') as json_file:
        json.dump(data, json_file, indent=4, ensure_ascii=False)

    print(f"Converted {csv_file_path} to {json_file_path} successfully.")

# Example usage
csv_file_path = 'D:/Projects/Godot Projects/zhuyin_input_practice/resources/character_zhuyin_dictionary.csv'  # Replace with your CSV file path
json_file_path = 'D:/Projects/Godot Projects/zhuyin_input_practice/resources/character_zhuyin_dictionary.json'   # Replace with your desired JSON file path
csv_to_json(csv_file_path, json_file_path)