# terraform-nomad-oraclecloud
A mini nomad cluster using oracle cloud free tier resources

create a backend.config file with the content

<code>
hostname = "app.terraform.io"

organization = "YOUR ORGANIZATION"

workspaces {
  name = "terraform-nomad-oraclecloud"
}
</code>

Configure your backend with

<code>
terraform init --backend-config=backend.config
</code>
