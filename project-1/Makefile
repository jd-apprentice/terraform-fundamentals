init:
	terraform init

apply:
	terraform apply -auto-approve -var-file="secret.tfvars"

clean:
	rm terraform.tfstate

destroy:
	terraform destroy -auto-approve