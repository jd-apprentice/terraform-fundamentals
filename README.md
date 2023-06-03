# 💜 Terraform Practice

![IMG](https://www.scalefactory.com/blog/2021/12/22/terraform-v1.1-the-journey-continues/tf11x.png)

## 1. Terraform Installation

### 1.1. Install Terraform on Linux

#### 1.1.1. Download Terraform

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

#### 1.1.2. Verify Terraform Installation

```bash
which terraform
```

#### 2. Examples

##### 2.1. Create a Nginx Server

```bash
cd nginx
terraform init
terraform apply
```

##### 2.2. Create a AWS EC2 Instance

- Requirements:
  - AWS Account with Free Tier
  - AWS CLI
  - AWS IAM User with Sufficient Permissions
  - AWS IAM User Access Key and Secret Key

```bash
cd aws
terraform init
terraform apply
```

##### 2.3. Create a AWS EC2 Instance with variables

```bash
cd aws
terraform init
terraform apply -var "instance_name=HoliComoEstas"
```

##### 2.4. Create a output for the AWS EC2 Instance

See [output.tf](/aws/outputs.tf) file for more information about what is going to be outputed.

```bash
cd aws
terraform output
```

##### 2.5. Destroy a Terraform Resource

```bash
cd <folder>
terraform destroy
```

##### 2.6. Use terraform cloud

We can use the following code

```hcl
terraform {

  cloud {
    organization = "jd_apprentice"
    workspaces {
      name = "learn-tfc-aws"
    }
  }

}

provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-08d70e59c07c61a3a"
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
}
```

And then we can use the following commands

```bash
terraform login
terraform init
```

With this brefly explanation we covered the following topics:

![IMG](https://i.imgur.com/DRHz8ea.png)

##### 3. Project examples

Here are examples of production ready projects that I have added terraform in order to learn how to use it.

- [Python-FastAPI](./project-1/README.md)

Resources:

- [INSTALL](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
- [REGISTRY](https://registry.terraform.io/)