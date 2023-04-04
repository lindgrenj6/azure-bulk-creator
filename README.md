# Azure RHEL Management Bulk-Uploader

**Requirements**:
- curl
- jq

This is a bulk-upload tool for importing many Azure accounts into console.redhat.com's RHEL Management Application.

To run this one needs a couple things:
1. Credentials to console.redhat.com with the `Sources Administrator` role in RBAC
2. 1..n Azure Accounts one wants to set up with RHEL Management

### File(s) needed
To manage these many sources in console.redhat.com the scripts just read from a csv file, by default it looks in the current directory for `accounts.csv`. The format of this document is very simple and looks like this:

| Name | Tenant |
| -------- | ------ |
| Test1 | 1234-1234 |

The source name is just the vanity name (maybe a hostname) the tenant can just be the subscription ID or any other uuid. 

After running the ansible-playbook to set up the source for gold images just add an entry for it in the CSV file to be created/destroyed later.

## Creating the resources
A Makefile has been provided to make running the script easier (e.g. it checks that all of the environment variables are set correctly).

simply run `make USER=myuser PASSWORD=hunter2 INPUT=accounts.csv create` and the script will create an instance to track that source in console.redhat.com

*NOTE*: Do not change the CSV file after running this command! If you want to destroy the resources later we need the names to match in order to find and destroy them.

## Destroying the resources
Much the same as creating the resources, except instead of creating it just filters the user's sources by the name and destroys that record.

`make USER=myuser PASSWORD=hunter2 INPUT=accounts.csv destroy`

tip: if something did change (e.g. someone deleted a source from the UI) the destroy script will fail. It is probably easiest to just delete that record from the CSV to delete the rest.
