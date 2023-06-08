init:
	terraform init

upgrade:
	terraform init -upgrade

plan:
	terraform plan -var-file="secret.tfvars"

apply:
	terraform apply -auto-approve -var-file="secret.tfvars"

clean:
	rm terraform.tfstate

destroy:
	terraform destroy -auto-approve