import os
import sys
from azure.identity import ClientSecretCredential
from azure.mgmt.compute import ComputeManagementClient

def remove_vm_instance(subscription_id, resource_group_name, scale_set_name, instance_id):
    tenant_id = os.environ['AZURE_TENANT_ID']
    client_id = os.environ['AZURE_CLIENT_ID']
    client_secret = os.environ['AZURE_CLIENT_SECRET']
    
    credential = ClientSecretCredential(tenant_id=tenant_id, client_id=client_id, client_secret=client_secret)
    compute_client = ComputeManagementClient(credential, subscription_id)

    # Deleting the specific instance from the VM Scale Set
    async_vm_delete = compute_client.virtual_machine_scale_set_vms.begin_delete(
        resource_group_name,
        scale_set_name,
        instance_id
    )
    async_vm_delete.result()
    print(f"VM instance {instance_id} deleted from scale set {scale_set_name}")

if __name__ == "__main__":
    subscription_id = os.environ['AZURE_SUBSCRIPTION_ID']
    resource_group_name = sys.argv[1]
    scale_set_name = sys.argv[2]
    instance_id = sys.argv[3]

    remove_vm_instance(subscription_id, resource_group_name, scale_set_name, instance_id)
