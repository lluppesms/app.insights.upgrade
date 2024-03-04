# Azure DevOps Deployment Template Notes

## 1. Azure DevOps Template Definitions

Typically, you would want to set up either the first option or the second and third option, but not all three jobs.

- **upgrade-app-insights.yml:** Deploys or upgrades app insights instances

---

## 2. Deploy Environments

These Azure DevOps YML files were designed to run as multi-stage environment deploys (i.e. DEV/QA/PROD). Each Azure DevOps environments can have permissions and approvals defined. For example, DEV can be published upon change, and QA/PROD environments can require an approval before any changes are made.

---

## 3. Setup Steps

- [Create Azure DevOps Service Connections](https://docs.luppes.com/CreateServiceConnections/)

- [Create Azure DevOps Environments](https://docs.luppes.com/CreateDevOpsEnvironments/)

- [Create Azure DevOps Pipeline(s)](https://docs.luppes.com/CreateNewPipeline/)

- [Deploy the Azure Resources and Application](./Docs/DeployApplication.md)
