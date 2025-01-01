__author__ = "David Koch"

import configparser
from jira import JIRA
import pandas as pd
import csv

if __name__ == "__main__":
    config = configparser.ConfigParser()
    config.read("secret.ini")

    JIRA_URL = config["jira"]["JIRA_URL"]
    USERNAME = config["jira"]["USERNAME"]
    API_TOKEN = config["jira"]["API_TOKEN"]
    PROJECT_KEY = config["jira"]["PROJECT_KEY"]

    jira = JIRA(server=JIRA_URL, basic_auth=(USERNAME, API_TOKEN))
    jql_query = f"project = {PROJECT_KEY}"

    issues = jira.search_issues(jql_query, maxResults=False)
    tasks = []

    for issue in issues:
        clockify_time = getattr(issue.fields.timetracking, "remainingEstimate")
        if clockify_time:
            clockify_time = issue.fields.timetracking.raw["timeSpentSeconds"]
        else:
            clockify_time = 0

        tasks.append({
            "Key": issue.key,
            "Summary": issue.fields.summary,
            "Description": issue.fields.description,
            "Status": issue.fields.status.name,
            "Assignee": issue.fields.assignee.displayName if issue.fields.assignee else "Unassigned",
            "Created": issue.fields.created,
            "Updated": issue.fields.updated,
            "Timetracking": clockify_time,
            "DueDate": issue.fields.duedate,
        })

    df = pd.DataFrame(tasks)
    csv_file = "jira_fenrir_tasks.csv"
    df.to_csv(csv_file, index=False, quoting=csv.QUOTE_ALL)

    print(f"Exported {len(tasks)} tasks to {csv_file}")
