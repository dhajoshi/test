import os
import sys
from azure.identity import DefaultAzureCredential
from azure.mgmt.compute import ComputeManagementClient

# Read input parameters
resource_group_name = sys.argv[1]
vmss_name = sys.argv[2]
instance_id = sys.argv[3]

# Authenticate
credential = DefaultAzureCredential()
subscription_id = os.environ["AZURE_SUBSCRIPTION_ID"]

compute_client = ComputeManagementClient(credential, subscription_id)

# Delete the VM instance from the VM scale set
compute_client.virtual_machine_scale_set_vms.delete(
    resource_group_name=resource_group_name,
    vm_scale_set_name=vmss_name,
    instance_id=instance_id
)

print(f"Instance {instance_id} from VM Scale Set {vmss_name} in Resource Group {resource_group_name} has been deleted.")
