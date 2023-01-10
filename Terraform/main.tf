terraform {
  required_providers {
    launchdarkly = {
      source  = "launchdarkly/launchdarkly"
    }
  }
}

variable "LAUNCHDARKLY_ACCESS_TOKEN" {
  type = string
}

provider "launchdarkly" {
  access_token = var.LAUNCHDARKLY_ACCESS_TOKEN
}

resource "launchdarkly_project" "reactv2" {
  key  = "ld-demo-reactv2"
  name = "ld-demo-reactv2"

  tags = [
    "terraform",
  ]

  environments {
        key   = "reactv21"
        name  = "reactv2-1"
        color = "7B42BC"
        tags  = ["terraform"]
  }
  default_client_side_availability {
    using_environment_id = true
    using_mobile_key     = false
  }
}

resource "launchdarkly_feature_flag" "qrcode" {
  project_key = launchdarkly_project.reactv2.key
  key         = "qrcode"
  name        = "0 - QR Code"
  description = "Scan the QR code in the application in order to access the demo locally!"

  variation_type = "boolean"
  variations {
    value       = "true"
    name        = "QR Code On"
    description = "Show the QR Code"
  }
  variations {
    value       = "false"
    name        = "QR Code Off"
    description = "Disable the QR Code for mobile device viewing "
  }
  
  defaults {
    on_variation = 0
    off_variation = 1
  }

  tags = [
    "terraform-managed"
  ]
}

resource "launchdarkly_feature_flag" "login" {
  project_key = launchdarkly_project.reactv2.key
  key         = "login"
  name        = "1 - APP UI (Release a New UI)"
  description = "Features can be text on screen, new web components, API changes, or new infrastructure entirely"

  variation_type = "boolean"
  variations {
    value       = "true"
    name        = "Show New Header Design"
    description = "Show the updated LaunchDarkly header"
  }
  variations {
    value       = "false"
    name        = "Show Old Header Design"
    description = "Displays header showing common app delivery "
  }
  
  defaults {
    on_variation = 0
    off_variation = 1
  }

  tags = [
    "terraform-managed",   
  ]
}

resource "launchdarkly_feature_flag" "bgstyle" {
  project_key = launchdarkly_project.reactv2.key
  key         = "bgstyle"
  name        = "2 - Background Styling (Targeting)"
  description = "We can control how features are released based on various targeting properties, like the coloring of a background image!"

  variation_type = "string"
  variations {
    value       = "./ld-bg-yellow.png"
    name        = "Grid background with yellow"
    description = "Standard background with yellow spots"
  }
  variations {
    value       = "./ld-bg.png"
    name        = "Standard grid background"
    description = "Standard background"
  }
  variations {
    value       = "./ld-bg-gray.png"
    name        = "Grid background with gray"
    description = "Standard background with gray spots"
  } 
  
  defaults {
    on_variation = 0
    off_variation = 1
  }

  tags = [
    "terraform-managed",   
  ]
}

resource "launchdarkly_feature_flag" "apidebug" {
  project_key = launchdarkly_project.reactv2.key
  key         = "apidebug"
  name        = "3 - API Menu (Hide a debug menu)"
  description = "Features can be hidden behind debugging feature flags"

  variation_type = "boolean"
  variations {
    value       = "true"
    name        = "Enable Debug Menu"
    description = "Displays the hidden admin debugging menu for DB"
  }
  variations {
    value       = "false"
    name        = "No Debug Menu"
    description = "Disable the debug menu flag"
  }
  
  defaults {
    on_variation = 0
    off_variation = 1
  }

  tags = [
    "terraform-managed",   
  ]
}

resource "launchdarkly_feature_flag" "dbinfo" {
  project_key = launchdarkly_project.reactv2.key
  key         = "dbinfo"
  name        = "4 - Switch Database (Migration)"
  description = "Use feature flags to **migrate** to a new infrastructure service (like a **database**)"

  variation_type = "json"
  variations {
    value       = jsonencode({"dbhost": "dynanmo","mode": "cloud"})
    name        = "Cloud"
    description = "Enable the Cloud hosted database"
  }
  variations {
    value       = jsonencode({"dbhost": "db","mode": "local"})
    name        = "LocalDB"
    description = "Use local database"
  }
  
  defaults {
    on_variation = 0
    off_variation = 1
  }

  tags = [
    "terraform-managed",   
  ]
}

output "LaunchDarkly_Server_Key" {
  value = launchdarkly_project.reactv2.environments[0].api_key
  sensitive = true
}

output "LaunchDarkly_Client_Side_Key" {
  value = launchdarkly_project.reactv2.environments[0].client_side_id
  sensitive = true
}
