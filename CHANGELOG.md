# Changelog

All notable changes to this project will be documented in this file.

## v0.2.6 - 2022-10-14
#### Changed
* Platform AMI update to version 2.0.4650.  Contact GrayMeta for more details
## v0.2.5 - 2021-05-27
#### Changed
* Platform AMI update to version 2.0.4634.  Contact GrayMeta for more details
## v0.2.4 - 2020-09-01
#### Changed
* Platform AMI update to version 2.0.4496.  Contact GrayMeta for more details
  
---
## v0.2.3 - 2020-07-13
#### Added
* Added Logograb key
    ```
    module "platform" {
      ...
      # (Optional) logograb
      logograb_key = ""
      ...
    }
    ```
* Added Azure AD SAML instructions.  [README-saml](README-saml.md)
* Added Onedrive and Sharepoint/Teams Oauth.  [README-oauth-storage](README-oauth-storage.md)
#### Changed
* Platform AMI update to version 2.0.4442.  Contact GrayMeta for more details

---
## v0.2.2 - 2020-05-14
#### Added
* Added ML Service NLP.
    ```
    # nlp - (Optional) Language Detection - GrayMeta extractor.
    module "nlp" {
      source = "github.com/graymeta/terraform-aws-platform//modules/ml_services/nlp?ref=v0.2.2"

      instance_type          = "m5.large"
      max_cluster_size       = "2"
      min_cluster_size       = "1"
      ml_loadbalancer_output = "${module.ml_network.ml_loadbalancer_output}"
      services_ecs_cidrs     = ["${module.network.ecs_cidrs}", "${module.network.services_cidrs}"]
    }

    output "nlp_endpoint" {
      value = "${module.nlp.endpoint}"
    }
    ```
#### Changed
* Platform AMI update to version 2.0.4391.  Contact GrayMeta for more details

---
## v0.2.1 - 2020-03-25
#### Added
* Added AWS Rekognition Custom Labels.  You will have to add the following variables to the platform module.
    ```
    module "platform" {
      ...
      # AWS Rekognition Custom Labels Configuration
      aws_cust_labels_bucket          = "somebucket"
      aws_cust_labels_inference_units = "1"
      ...
    }
    ```
* Cloudwatch Dashboard name GrayMetaPlatform-<platform_instance_id>.  You will need to add the following variable to the platform module.
    ```
    module "platform" {
      ...
      proxy_asg = "${module.network.proxy_asg}"
      ...
    }
    ```

---
## v0.2.0 - 2019-11-18
#### Upgrade Notes:  
* Please follow the following steps if you are upgrading to this version
  1. This version requires upgrading Postgres database to 11.5.  Before you run `terraform apply` it is recommended that you go into the AWS console and update the version to 10 and choose apply immediately.  Then do it again and update to 11.5.
  1. Update the version in your code and run a `terraform apply`
  1. Connect to the platform postgres system and run the following.
      * Connecting to postgres - ssh into one of those service instances, become root and run the following
        ```
        yum install postgresql -y
        export $(grep ^gm_db /etc/graymeta/metafarm.env)
        PGPASSWORD=$gm_db_password psql -h $gm_db_host -U $gm_db_username -d $gm_db_name
        ```
      * Once in the postgres command prompt run
        ```
        TRUNCATE items CASCADE;
        DELETE FROM hashes;
        ```
  1. Run a reindex.
  

#### Added
* Monitoring your GrayMeta Platform Instance.  [README-monitoring](README-monitoring.md)
  * Preflight check for elasticsearch heath
  * Preflight check for SES configuration
  * Preflight check for autoscaling and instance health
  * Preflight check for extractor configurations using temp s3 bucket
  * Preflight check for file and usage s3 bucket `Public Access Block`
    * Example to enable `Public Access Block`:
      ```
      resource "aws_s3_bucket_public_access_block" "file_s3_bucket" {
        bucket                  = "<bucket name>"
        block_public_acls       = true
        block_public_policy     = true
        ignore_public_acls      = true
        restrict_public_buckets = true
      }
      ```
* Graphite/Statsite server
  * Add the following variables to network module
    ```
    module "network" {
      ...
      # Graphite/Statsite server
      statsite_instance_type = "m4.large"
      statsite_volume_size   = "100"
      ...
    }
    ```
  * Add the following variables to platform module
    ```
    module "platform" {
      ...
      statsite_ip  = "${module.network.statsite_ip}"
      statsite_nsg = "${module.network.statsite_nsg}"
      ...
    }
    ```  
  * Add the following variables to ml_network module
    ```
    module "ml_network" {
      ...
      customer     = "${local.customer}"
      statsite_ip  = "${module.network.statsite_ip}"
      statsite_nsg = "${module.network.statsite_nsg}"
      ...
    }
    ```
* SAML Configuration - More infomation [README-saml](README-saml.md)
  * `saml_attr_email` - The name of the SAML Attribute containing the user's email address. Default: email
  * `saml_attr_firstname` - The name of the SAML Attribute containing the user's first name. Default: firstname
  * `saml_attr_lastname` - The name of the SAML Attribute containing the user's last name. Default: lastname
  * `saml_attr_uid` - The name of the SAML Attribute containing a unique ID for the user. Usernames are a bad choice as they could change for the user. Default: uid
  * `saml_cert` - base64 encoded string representation of a self-signed x509 certificate used to communicate with your SAML IDP
  * `saml_idp_metadata_url` - SAML Identity Provider metadata url
  * `saml_key` -base64 encoded string representation of the private key for the self-signed x509 certificate used to communicate with your SAML IDP

  * Added the following variables to platform module
    ```
    module "platform" {
      ...
      # (Optional) SAML Configuration
      saml_attr_email       = "email"
      saml_attr_firstname   = "firstname"
      saml_attr_lastname    = "lastname"
      saml_attr_uid         = "uid"
      saml_cert             = ""
      saml_idp_metadata_url = ""
      saml_key              = ""
      ...
    }
    ```
* Ability to adjust Elasticsearch number of replicas and shards.  Default replicas: 1, Default shards: 5
  ```
  module "platform" {
    ...
    gm_es_replicas = "1"
    gm_es_shards = "5"
    ...
  }
  ```

 #### Changed
* Default postgres database is now 11.5 for the platform
* Add `.digitaloceanspaces.com` and `.okta.com` to the proxy safelist
* Add `s3:GetBucketPublicAccessBlock`, `logs:CreateExportTask`, `logs:DescribeExportTasks` permissions to Service ec2 instances.
* Add permission for Services role to export cloudwatch logs to Graymeta bucket.
* Platform AMI update to version 2.0.  Contact GrayMeta for more details

---
## v0.1.12 - 2019-08-27
#### Added
* GM Celeb - **NOTE: If previously using awsrekog make sure you update provider setting since default changed**
  * `gm_celeb_detection_enabled` - Whether or not celeb detection is enabled.  Default: false
  * `gm_celeb_detection_interval` - Celeb detection interval. Valid values must be parseable as a Golang time.Duration (see https://godoc.org/time#ParseDuration).  Default: 5m
  * `gm_celeb_detection_min_confidence` - Celeb detection min confidence. Recommended for gmceleb is 0.5, awsrekog is 90  Default: 0.6"
  * `gm_celeb_detection_provider` - Celeb detection provider. Valid values are gmceleb or awsrekog.  Default: gmceleb
    ```
    module "platform" {
      ...
      # (Optional) Celeberty detection
      gm_celeb_detection_enabled        = "true"
      gm_celeb_detection_interval       = "5m"
      gm_celeb_detection_min_confidence = "0.6"
      gm_celeb_detection_provider       = "gmceleb"
      ...
    }
    ```
  
#### Removed
* The slates extractor has been removed.  The slates/clapperboard extractor endpoint should now use the Technical Cues API (tcues).  Remove if you have this module defined.
  ```
  # slates - (Optional) Slates extractor
  module "slates" {
    ...
  }

  output "slates_endpoint" {
    ...
  }
  ```
  
* Removed terraform providers from all modules.  Recommended to have the following version in the root module of a configuration.
    ```
    provider "aws" {
      region  = "us-west-2"
      version = "~> 1.16"
    }
    ```

#### Changed
* Updated the ML Cloudwatch stream names for all the ML containers running.
* Add `ses:GetAccountSendingEnabled` and `ses:GetIdentityVerificationAttributes` permissions to Service ec2 instances.
* Platform AMI update to version 2.0.3781.  Contact GrayMeta for more details

---
## v0.1.11 - 2019-08-07
**We have a database type change for ML Faces service in this release.  If you are upgrading you will have to follow the instructions in `ML Face RDS Migration` section below**

#### ML Face RDS Migration
Changing ML Faces database to use Aurora RDS with a scaling read replicas configured.  
* The following variables have been removed from the module.
  * rds_allocated_storage
  * rds_multi_az
* Also for the instance size the default change to db.r4.2xlarge.
  * supported instance types [DBInstanceClass](https://docs.aws.amazon.com/AmazonRDS/latest/AuroraUserGuide/Concepts.DBInstanceClass.html)
* Process to migrate.
  1. Before upgrading to the latest version you must first destory the faces module.
      * Run `terraform destroy -target module.faces`
  1. On the Destroy AWS will create a final snapshot of the RDS database.  For migrating to Aurora we need to look up that snapshot ARN.
      * In the AWS Console go to RDS -> Snapshots -> Look for a snapshot with the name format of `GrayMetaPlatform-<platform_instance_id>-faces-final` We will need the full arn in the next step.
  1. In the `module.faces` place the ARN found on the previous step in the `rds_snapshot` variable.
      ```
        module "faces" {
          ...
          rds_snapshot = "arn:aws:rds:us-west-2:1111111111:snapshot:graymetaplatform-testsys-faces-final"
          ...
        }
      ```
  1. Additional Optional Options for `module.faces`
      * rds_asg_target_cpu - Target CPU for the ASG group.  Default: 80
      * rds_asg_max_capacity - ASG Maximum number of read replicas.  Default: 15, Min: 1, Max: 15
  1. Upgrade the `module.faces` source to v0.1.10 or higher and do a `terraform apply`
  1. After the upgrade is complete don't forget to change the `rds_snapshot` variable back to `final`
        ```
        module "faces" {
          ...
          rds_snapshot = "final"
          ...
        }
      ```

#### Added
* AWS Celeb
  * gm_celeb_detection_enabled - Whether or not celeb detection is enabled.  Default: false
  * gm_celeb_detection_interval - Celeb detection interval. Valid values must be parseable as a Golang time.Duration (see https://godoc.org/time#ParseDuration).  Default: 5m
    ```
    module "platform" {
      ...
      # (Optional) AWS Celeberty detection
      gm_celeb_detection_enabled  = true
      gm_celeb_detection_interval = "5m"
      ...
    }
    ```
  
* Added ML Technical Cues extractor.  This new api will be replacing credits extractor cluster.
  ```
  # tcues - (Optional) Technical Cues extractor.
  module "tcues" {
    source = "github.com/graymeta/terraform-aws-platform//modules/ml_services/tcues?ref=v0.1.10"

    instance_type          = "m5.large"
    max_cluster_size       = "2"
    min_cluster_size       = "1"
    ml_loadbalancer_output = "${module.ml_network.ml_loadbalancer_output}"
    services_ecs_cidrs     = ["${module.network.ecs_cidrs}", "${module.network.services_cidrs}"]
  }

  output "tcues_endpoint" {
    value = "${module.tcues.endpoint}"
  }
  ```

#### Removed
* The credits extractor cluster has been removed.  The credits extractor endpoint should now use the Technical Cues API (tcues).  Remove if you have this module defined.
  ```
  # credits - (Optional) Credits extractor
  module "credits" {
    ...
  }

  output "credits_endpoint" {
    ...
  }
  ```

#### Changed
* Changed the platform gm_es_bulk_size default from -1 to 20000000
* Platform AMI update to version 2.0.3712.  Contact GrayMeta for more details
 

---
## v0.1.10 - 2019-07-30
#### Added
* Added a chronyd to the userdata


---
## v0.1.9 - 2019-05-31
#### Changed
* Platform AMI update to version 2.0.3533.  Contact GrayMeta for more details

---
## v0.1.8 - 2019-05-10
#### Added
* Curio license server to proxy safe list
* Flask port to the faces environment variables
* Tensorflow container to NLD service

#### Changed
* Platform AMI update to version 2.0.3464.  Contact GrayMeta for more details

---
## v0.1.7 - 2019-03-29
#### Added
* Added a Celeb model to faces cluster.

#### Changed
* Bypass the webproxy for s3 buckets in the same region as platform.
* Rename docker environment variables in faces cluster.
* Updated the default number of ES workers in the data_api.
* Changed the ELB health check endpoint.
* Platform AMI update to version 2.0.3280.  Contact GrayMeta for more details

---
## v0.1.6 - 2019-02-15
#### Added
* Added AWS Comprehend to IAM Policy.

#### Changed
* Platform AMI update to version 2.0.3045.  Contact GrayMeta for more details

---
## v0.1.5 - 2019-02-11
#### Added
* Added a new MLservice modules to install clusters for Graymeta Machine Learning services. Please see [README-MLservices.md](README-MLservices.md)

#### Changed
* In the Network Module we renamed the following variables.
  ```
  cidr_subnet_faces_1 => cidr_subnet_mlservices_1
  cidr_subnet_faces_2 => cidr_subnet_mlservices_2
  ```

* Faces module has moved.  Please see [README-MLservices.md](README-MLservices.md)

* Removed AMI variables `ecs_amis`, `services_amis`, `proxy_amis`, and `faces_amis` from all modules.  

* Platform AMI update to version 2.0.3008.  Contact GrayMeta for more details

---
## v0.1.4 - 2019-01-25

#### Added
* Added a new SQS named `GrayMetaPlatform-<platform_instance_id>-itemcleanup`

#### Changed
* Platform AMI update to version 2.0.2921.  Contact GrayMeta for more details
  
---
## v0.1.3 - 2019-01-07

#### Added
* Added Segment.com Analytics Write Key. Set to an empty string to disable analytics.
  ```
  module "platform" {
    ...
    segment_write_key = ""
    ...
  }
  ```

* Added a Node protection service.  This service will mark nodes working on critical workloads as protected in the AutoScaling Group.

#### Changed
* Platform AMI update to version 2.0.2788.  Contact GrayMeta for more details
  
---
## v0.1.2 - 2018-12-28

#### Added
* Added a new module named usage.  This is to help setup the permissions needed for Graymeta to access the usage bucket.
  ```
  module "share_usage" {
    source = "github.com/graymeta/terraform-aws-platform//modules/usage?ref=v0.1.2"

    usage_s3_bucket_arn = ""arn:aws:s3:::cfn-file-api""
  }
  ```

* Added `services_scale_down_threshold_cpu` and `services_scale_up_threshold_cpu` variables.  Should not set unless directed by support@graymeta.com

#### Changed
* Updated ECS AMI to use amazon linux 2
* Platform AMI update to version 2.0.2763.  Contact GrayMeta for more details

---
## v0.1.1 - 2018-12-14

#### Added

* Added a gm_license_key.  Contact support@graymeta.com if you have not been provided a license key.  Please include your `dns_name` in your request for a license.  If you add this variable to your `encrypted_config_blob` then you can set this to empty string. 
  ```
      module "platform" {
        ...
        gm_license_key = ""
        ...
      }
  ```

* Added centralized Oauth service into box/dropbox.  32 character encryption key.  If added to `encrypted_config_blob` then this variable must be set to `""`.  
  ```
      module "platform" {
        ...
        oauthconnect_encryption_key = "012345678901234567890123456789ab"
        ...
      }
  ```

* (Optional) No longer required for SES to be configured in the same region as the platform.  If you have SES in another region just add the following to the platform module.  Default is the same region as the platform if left blank.
  ```
      module "platform" {
        ...
        notifications_region = "us-west-2"
        ...
      }
  ```

* (Optional) Accounts will now be locked out after numerous failed login attempts in a given timeframe. The lockouts are tuneable with the following parameters:
  * `account_lockout_attempts` - The number of failed login attempts that will trigger an account lockout. Default: 5
  * `account_lockout_interval` - The amount of time an account is locked out after exceeding the threshold for number of failed logins. Default: 10m.  Valid values must be parseable as a Golang [time.Duration](https://godoc.org/time#ParseDuration)
  * `account_lockout_period` - The window of time for failed login attempts to trigger an account lockout. Default: 10m.  Valid values must be parseable as a Golang [time.Duration](https://godoc.org/time#ParseDuration)
    ```
        module "platform" {
          ...
          account_lockout_attempts = "5"
          account_lockout_interval = "10m"
          account_lockout_period = "10m"
          ...
        }
    ```

* (Optional). Minimum password length is now a configurable option. Default is 8 characters long
  ```
      module "platform" {
        ...
        password_min_length = "8"
        ...
      }
  ```

#### Changed

* (Optional). Box.com and Dropbox support has been refactored. Please see the [OAuth storage provider README](README-oauth-storage.md) for details.
  ```
      module "platform" {
        ...
        # (Optional) OAuth-storage
        box_com_client_id  = "your box.com client id"
        box_com_secret_key = "your box.com client secret"
        dropbox_app_key    = "your Dropbox application key"
        dropbox_app_secret = "your Dropbox application secret"
        ...
      }
  ```

---
## [v0.1.0] - 2018-10-24
**Upgrading to this release will cause an outage while the proxy cluster is created, and Services and ECS instances are recreate.**

#### Added
* Two new subnets for proxy instances in the network module.  You need to apply only if the default value for vpc_cidr was not used.
  ```
      module "network" {
        ...
        cidr_subnet_proxy_1 = "10.0.20.0/24"
        cidr_subnet_proxy_2 = "10.0.21.0/24"
        ...
      }
  ```
   
* Added a Proxy cluster in the network module.  All routes from other subnets to NAT gateway have been removed.  This will create a new internal loadbalancer with proxy instances.  All outbound api requests are now locked down by the proxy cluster.  The autoscaling thresholds should be adjusted for the instance type.
  ```
      module "network" {
        ...
        # Proxy Cluster
        dns_name               = "foo.cust.graymeta.com"
        key_name               = "${local.key_name}"
        log_retention          = "7"
        proxy_instance_type    = "m4.large"
        proxy_max_cluster_size = 4
        proxy_min_cluster_size = 2
        proxy_scale_down_thres = "12500000" # bytes = 100 Mb/s
        proxy_scale_up_thres   = "50000000" # bytes = 400 Mb/s
        ssh_cidr_blocks        = "10.0.0.0/24,10.0.1.0/24"
        ...
      }
  ```
   
* Add the Proxy endpoint variable to the platform module.
  ```
      module "platform" {
        ...
        proxy_endpoint = "${module.network.proxy_endpoint}"
        ...
      }
  ```

* (Optional) Added Credits to the Faces cluster.  To setup the extractor in the UI you need the credits endpoint.  In the UI go to Settings -> Extractors -> Credits.  Then insert the output from credits_endpoint in the Hostname field.
  ```
      output "credits_endpoint" {
          value = "${module.faces.credit_endpoint}"
      }
  ```
  
* (Optional) Added Slates to the Faces cluster.  To setup the extractor in the UI you need the slates endpoint.  In the UI go to Settings -> Extractors -> Slates.  Then insert the output from slates_endpoint in the Hostname field.
  ```
      output "slates_endpoint" {
          value = "${module.faces.slates_endpoint}"
      }
  ```
  
#### Changed
* Now creating ECS nodes in two AZ.  Network Module we renamed the `cidr_subnet_ecs` subnet to `cidr_subnet_ecs_1` and added a `cidr_subnet_ecs_2`.  Recommended that cidr_subnet_ecs_2 to be a /21 subnet.  You need to apply only if the default value for vpc_cidr was not used.
  ```
      module "network" {
        ...
        cidr_subnet_ecs_1 = "10.0.8.0/21"
        cidr_subnet_ecs_2 = "10.0.24.0/21"
        ...
      }
  ```
  
* Now creating ECS nodes in two AZ.  In the Platform module rename `ecs_subnet_id` variable to `ecs_subnet_id_1`.  Then add the `ecs_subnet_id_2` variable.
  ```
      module "platform" {
        ...
        ecs_subnet_id_1 = "${module.network.ecs_subnet_id_1}"
        ecs_subnet_id_2 = "${module.network.ecs_subnet_id_2}"
        ...
      }
  ```
  
* Renamed the ElastiCache instance so multiple platforms in the same region can be supported.

* Platform AMI update to version 2.0.2472.  Contact GrayMeta for more details

#### Removed
* Removed facebox from the platform module.  Please delete the following variables.
  ```
      module "platform" {
        ...
        elasticache_instance_type_facebox  = "cache.m4.large"
        facebox_key = ""
        ...
      }
  ```
   
---
## [v0.0.32] - 2018-09-17
#### Added
* Added variable for the RDS backup retention and window within the platform module.  The default retention is now set to 7 days and a backup window set to 03:00-04:00.  Previous versions this was not set.  This will create a pending update for the next maintenance window.
  ```
      module "platform" {
        source = "github.com/graymeta/terraform-aws-platform?ref=v0.0.32"
        ...
        db_backup_retention = "7"
        db_backup_window    = "03:00-04:00"
        ...
      }
  ```

* Added variable to set the RDS as a multi_az.  Default is now set to true.  Previous versions this was not set.  This will create a pending update for the next maintenance window.
  ```
      module "platform" {
        source = "github.com/graymeta/terraform-aws-platform?ref=v0.0.32"
        ...
        db_multi_az = true
        ...
      }
  ```
  
* Added two new subnets for faces in the network module.  You need to apply only if the default value for vpc_cidr was not used.
  ```
      module "network" {
        source = "github.com/graymeta/terraform-aws-platform//modules/network?ref=v0.0.32"
        ...
        cidr_subnet_faces_1 = "x.x.x.x/24"
        cidr_subnet_faces_2 = "x.x.x.x/24"
        ...
      }
  ```
  
* (Optional) Added Faces module.  More info at [README-faces](README-faces.md)
  
#### Changed
* Install 1 NAT Gateway in each AZ instead of one for Services and the other for ECS.  It is required to change the following two variable names in the platform module.  
  ```
      ecs_nat_ip      => az1_nat_ip
      services_nat_ip => az2_nat_ip
  ```
  
- Platform AMI update to version 2.0.2339.  Contact GrayMeta for more details
  
---
## [v0.0.31] - 2018-09-06  
#### Added
* (Optional) Added service and ecs cloud init settings.  These cloud-init's will be merged with GrayMeta cloud-init script.  Please check with GrayMeta support to verify your cloud-init scripts will not interfere with the defaults.
  ```
      module "platform" {
        source = "github.com/graymeta/terraform-aws-platform?ref=v0.0.31"
        ...
        services_user_init = "${data.template_file.service_data.rendered}"
        ecs_user_init      = "${data.template_file.ecs_data.rendered}"
        ...
      }
  ```
  
#### Removed

* Consolidated Redis environment variables on the backend of the service instances.  No template changes needed.
* Removed the Box.com variables since they are now configured in the UI.  Please remove if you have the following in the platform module.

  ```
      # Box (Box.com)
      box_client_id                    = ""
      box_client_secret                = ""
  ```
  
#### Changed
* Platform AMI update to version 2.0.2312.  Contact GrayMeta for more details
  
---
## [v0.0.30] - 2018-08-10
#### Changed
- Platform AMI update to version 2.0.2258.  Contact GrayMeta for more details
  
---
## [v0.0.29] - 2018-08-03
#### Added
* Variable to define Cloudwatch retention in platform module
  ```
      module "platform" {
        source = "github.com/graymeta/terraform-aws-platform?ref=v0.0.29"
        ...
        log_retention = "14"
        ...
      }
  ```
  
#### Changed
- Platform AMI update to version 2.0.2253.  Contact GrayMeta for more details
