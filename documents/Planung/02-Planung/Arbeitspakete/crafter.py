__author__ = "David Koch"

import pandas as pd

if __name__ == "__main__":
    df = pd.read_csv("jira_fenrir_tasks.csv")

    with open("Arbeitspaket_EMPTY.tex", "r", encoding="utf-8") as file:
        latex_template = file.read()

    with open("Fenrir_Arbeitspaketdefinition.tex", "w", encoding="utf-8") as output:
        for index, row in df[-1:].iterrows():
            latex_content = latex_template

            sum_split = row["Summary"].split(" ") # psp code & actual summary

            latex_content = latex_content.replace("*CODE*", sum_split[0])
            latex_content = latex_content.replace("*SUMMARY*", " ".join(sum_split[1:]))
            latex_content = latex_content.replace("*DESCRIPTION*",
                                                  row["Description"] if pd.notna(row["Description"]) else "")
            latex_content = latex_content.replace("*ASSIGNEE*", row["Assignee"].split(" ")[1][:3].upper() if row["Assignee"] != "Unassigned" else "XXX")
            latex_content = latex_content.replace("*TIMETRACKING*", str(row["Timetracking"]/3600))
            latex_content = latex_content.replace("*DUEDATE*", row["DueDate"] if pd.notna(row["DueDate"]) else "xx.xx.xxxx")

            output.write(latex_content)

