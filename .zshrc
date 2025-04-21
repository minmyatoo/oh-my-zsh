# Welcome message with daily quote
echo -e "\n🚀 \033[1;32mNetSuite Development Environment Loaded\033[0m"
echo -e "Type 'ns-api-help' or 'ns-record-help' for quick references\n"
echo -e "\033[1;35m📜 Your daily inspiration:\033[0m"
daily_quote_cache
echo -e "\n"# .zshrc configuration for NetSuite developers
# ========================================
# Installation steps:
# 1. Install Oh My Zsh: sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# 2. Install NVM: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
# 3. Install Node.js v16: nvm install 16
# 4. Install SuiteCloud CLI: npm install -g @oracle/suitecloud-cli
# 5. Copy this file to ~/.zshrc
# 6. Apply settings: source ~/.zshrc
# 7. Configure NetSuite authentication: suitecloud account setup
# ========================================

# ZSH Theme and Configuration
# --------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"  # A clean, minimal theme that works well
plugins=(git node npm nvm vscode)
source $ZSH/oh-my-zsh.sh

# Path Configuration
# -----------------
export PATH="$HOME/.suitecloud/cli:$HOME/node_modules/.bin:$PATH"

# NetSuite SuiteCloud SDK Setup
# ----------------------------
export SUITECLOUD_SDK="$HOME/.suitecloud/sdk"
export NODE_ENV="development"

# Node.js and NPM Configuration
# ---------------------------
# Set a specific Node.js version for NetSuite development
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
nvm use 16 >/dev/null 2>&1 || nvm use default >/dev/null 2>&1  # NetSuite currently works best with Node 16

# NetSuite Aliases
# ---------------
# Project navigation
alias nsgo="cd ~/projects/netsuite"
alias nsdev="cd ~/projects/netsuite/current-project"

# SuiteCloud CLI shortcuts
alias sdf="suitecloud"
alias sdfl="suitecloud listfiles"
alias sdfp="suitecloud project"
alias sdfa="suitecloud account"
alias sdfo="suitecloud object"
alias sdfd="suitecloud deploy"
alias sdfi="suitecloud import"
alias sdfu="suitecloud update"
alias sdfv="suitecloud validate"

# SuiteCloud Project Management
alias ns-create="suitecloud project create"
alias ns-validate="suitecloud project validate"
alias ns-deploy="suitecloud project deploy"
alias ns-importobj="suitecloud object import"
alias ns-importfiles="suitecloud file import"
alias ns-adddeps="suitecloud project adddependencies"

# SuiteCloud Authentication
alias ns-auth="suitecloud account savetoken"
alias ns-setup="suitecloud account setup"
alias ns-manageauth="suitecloud account manageauth"

# NetSuite Development Functions
# ----------------------------

# Create a new SuiteScript file with template
ns-newscript() {
  local scriptType=$1
  local scriptName=$2
  local folder=${3:-"SuiteScripts"}
  
  if [[ -z "$scriptType" || -z "$scriptName" ]]; then
    echo "Usage: ns-newscript <type> <name> [folder]"
    echo "Types: client, server, suitelet, restlet, mapreduce, scheduled, userevent, workflow, portlet"
    return 1
  fi

  local template=""
  local extension=".js"
  
  case "$scriptType" in
    client)
      template="/**\n * @NApiVersion 2.1\n * @NScriptType ClientScript\n */\ndefine([], function() {\n    return {\n        pageInit: function(context) {\n            // Logic on page init\n        },\n        fieldChanged: function(context) {\n            // Logic on field change\n        },\n        saveRecord: function(context) {\n            // Logic on save\n            return true;\n        }\n    };\n});"
      ;;
    server)
      template="/**\n * @NApiVersion 2.1\n */\ndefine([], function() {\n    function myFunction() {\n        // Function logic\n    }\n    \n    return {\n        myFunction: myFunction\n    };\n});"
      ;;
    suitelet)
      template="/**\n * @NApiVersion 2.1\n * @NScriptType Suitelet\n */\ndefine(['N/ui/serverWidget'], function(serverWidget) {\n    function onRequest(context) {\n        if (context.request.method === 'GET') {\n            // Handle GET request\n            var form = serverWidget.createForm({\n                title: 'Sample Form'\n            });\n            \n            context.response.writePage(form);\n        } else {\n            // Handle POST request\n        }\n    }\n    \n    return {\n        onRequest: onRequest\n    };\n});"
      ;;
    restlet)
      template="/**\n * @NApiVersion 2.1\n * @NScriptType Restlet\n */\ndefine([], function() {\n    function get(requestParams) {\n        // Handle GET request\n        return {\n            success: true,\n            message: 'GET request processed successfully'\n        };\n    }\n    \n    function post(requestBody) {\n        // Handle POST request\n        return {\n            success: true,\n            message: 'POST request processed successfully'\n        };\n    }\n    \n    return {\n        get: get,\n        post: post,\n        put: post,\n        delete: get\n    };\n});"
      ;;
    mapreduce)
      template="/**\n * @NApiVersion 2.1\n * @NScriptType MapReduceScript\n */\ndefine([], function() {\n    function getInputData() {\n        // Define input data\n        return {\n            type: 'search',\n            id: 'customsearch_my_search'\n        };\n    }\n    \n    function map(context) {\n        // Process each result in the getInputData stage\n        var searchResult = JSON.parse(context.value);\n        context.write({\n            key: searchResult.id,\n            value: searchResult\n        });\n    }\n    \n    function reduce(context) {\n        // Process data grouped by keys from the map stage\n        var values = context.values.map(JSON.parse);\n        // Reduce logic\n    }\n    \n    function summarize(summary) {\n        // Log results and handle errors\n        log.audit('Summary', 'Process complete');\n    }\n    \n    return {\n        getInputData: getInputData,\n        map: map,\n        reduce: reduce,\n        summarize: summarize\n    };\n});"
      ;;
    scheduled)
      template="/**\n * @NApiVersion 2.1\n * @NScriptType ScheduledScript\n */\ndefine(['N/search'], function(search) {\n    function execute(context) {\n        // Script logic\n        log.audit('Scheduled Script', 'Starting execution');\n        \n        // Your scheduled process logic here\n        \n        log.audit('Scheduled Script', 'Execution complete');\n    }\n    \n    return {\n        execute: execute\n    };\n});"
      ;;
    userevent)
      template="/**\n * @NApiVersion 2.1\n * @NScriptType UserEventScript\n */\ndefine(['N/record'], function(record) {\n    function beforeLoad(context) {\n        // Logic before record is loaded\n    }\n    \n    function beforeSubmit(context) {\n        // Logic before record is submitted\n    }\n    \n    function afterSubmit(context) {\n        // Logic after record is submitted\n    }\n    \n    return {\n        beforeLoad: beforeLoad,\n        beforeSubmit: beforeSubmit,\n        afterSubmit: afterSubmit\n    };\n});"
      ;;
    workflow)
      template="/**\n * @NApiVersion 2.1\n * @NScriptType WorkflowActionScript\n */\ndefine(['N/record'], function(record) {\n    function onAction(scriptContext) {\n        // Workflow action logic\n        return 'success';\n    }\n    \n    return {\n        onAction: onAction\n    };\n});"
      ;;
    portlet)
      template="/**\n * @NApiVersion 2.1\n * @NScriptType Portlet\n */\ndefine(['N/ui/serverWidget'], function(serverWidget) {\n    function render(params) {\n        var portlet = params.portlet;\n        portlet.title = 'My Custom Portlet';\n        \n        // Add content to the portlet\n        portlet.addLine({\n            text: 'Welcome to your custom dashboard portlet!'\n        });\n    }\n    \n    return {\n        render: render\n    };\n});"
      ;;
    *)
      echo "Unknown script type. See usage examples."
      return 1
      ;;
  esac
  
  # Create directory if it doesn't exist
  mkdir -p "$folder"
  
  # Create file with template
  echo -e "$template" > "$folder/${scriptName}${extension}"
  echo "Created $scriptType script at $folder/${scriptName}${extension}"
}

# Deploy specific file to NetSuite
ns-deploy-file() {
  local file=$1
  if [[ -z "$file" ]]; then
    echo "Usage: ns-deploy-file <filepath>"
    return 1
  fi
  
  suitecloud file:upload --paths "$file"
  echo "Deployed $file to NetSuite"
}

# Create new NetSuite project from scratch
ns-new-project() {
  local projectName=$1
  local accountId=$2
  
  if [[ -z "$projectName" || -z "$accountId" ]]; then
    echo "Usage: ns-new-project <project-name> <account-id>"
    return 1
  fi
  
  mkdir -p "$projectName"
  cd "$projectName"
  
  echo "Creating new NetSuite project: $projectName"
  suitecloud project:create -p "$projectName" -i
  
  echo "Setting up account authentication"
  suitecloud account:setup -a "$accountId"
  
  echo "Project $projectName created and configured successfully!"
}

# Search NetSuite records and export to CSV
ns-search-export() {
  local recordType=$1
  local searchId=$2
  local outputFile=${3:-"export.csv"}
  
  if [[ -z "$recordType" || -z "$searchId" ]]; then
    echo "Usage: ns-search-export <record-type> <search-id> [output-file]"
    return 1
  fi
  
  suitecloud object:import --scriptid "$searchId" --type savedsearch --destinationfolder ./tmp
  
  echo "Search exported to $outputFile"
}

# NetSuite record quick reference
ns-record-help() {
  echo "NetSuite Record Types Quick Reference:"
  echo "======================================="
  echo "customer          - Customer record"
  echo "salesorder        - Sales Order"
  echo "invoice           - Invoice"
  echo "inventoryitem     - Inventory Item"
  echo "assemblyvitem     - Assembly Item"
  echo "transaction       - Generic Transaction"
  echo "vendor            - Vendor"
  echo "purchaseorder     - Purchase Order"
  echo "vendorbill        - Vendor Bill"
  echo "journalentry      - Journal Entry"
  echo "employee          - Employee"
  echo "customrecord_*    - Custom Records"
}

# SuiteScript API quick reference
ns-api-help() {
  echo "SuiteScript 2.x Modules Quick Reference:"
  echo "========================================"
  echo "N/record         - Create, load, submit records"
  echo "N/search         - Search for records"
  echo "N/runtime        - Script runtime information"
  echo "N/format         - Format data values"
  echo "N/email          - Send emails"
  echo "N/file           - File operations"
  echo "N/https          - External API requests"
  echo "N/url            - URL creation and resolution"
  echo "N/render         - Templates and PDF generation"
  echo "N/ui/serverWidget - UI building (forms, fields)"
  echo "N/ui/message     - User interface messages"
  echo "N/task           - Schedule tasks and jobs"
  echo "N/util           - Utility functions"
  echo "N/config         - Configuration records access"
  echo "N/xml            - XML manipulation"
}

# Autocompletion for NetSuite commands
# -----------------------------------
_ns_script_types() {
  local types=("client" "server" "suitelet" "restlet" "mapreduce" "scheduled" "userevent" "workflow" "portlet")
  compadd "$@" $types
}

_ns_newscript() {
  _arguments \
    '1:script type:_ns_script_types' \
    '2:script name:' \
    '3:folder path:_files -/'
}

compdef _ns_newscript ns-newscript

# Environment indicator in prompt
# -----------------------------
# Add NetSuite account indicator to prompt if in a NetSuite project
netsuite_account_info() {
  if [[ -f "./suitecloud.config.js" ]]; then
    local account=$(grep -o '"accountId": "[^"]*' ./suitecloud.config.js | cut -d'"' -f4)
    echo "%{$fg[cyan]%}[NS:${account:0:8}]%{$reset_color%} "
  fi
}

# Modify prompt to show NetSuite account when in a project directory
export PROMPT='$(netsuite_account_info)'"$PROMPT"

# Terminal background image
# ------------------------
# Function to set a random terminal background image
set_terminal_background() {
  # Only run this in iTerm2 on macOS
  if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    # Directory for background images
    local bg_dir="$HOME/.terminal_backgrounds"
    
    # Create directory if it doesn't exist
    if [[ ! -d "$bg_dir" ]]; then
      mkdir -p "$bg_dir"
      
      # Download some default free images if the directory is empty
      if command -v curl &> /dev/null; then
        echo "Downloading terminal background images..."
        local image_urls=(
          "https://images.unsplash.com/photo-1507187632231-5beb21a654a2?w=1200&q=80" # Dark coding
          "https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=1200&q=80" # Code on screen
          "https://images.unsplash.com/photo-1542831371-29b0f74f9713?w=1200&q=80" # Code on laptop
          "https://images.unsplash.com/photo-1487058792275-0ad4aaf24ca7?w=1200&q=80" # Dark minimal
          "https://images.unsplash.com/photo-1484417894907-623942c8ee29?w=1200&q=80" # Workspace
        )
        
        for i in {1..5}; do
          curl -s "${image_urls[$i-1]}" -o "$bg_dir/bg_$i.jpg"
        done
        echo "Background images downloaded to $bg_dir"
      else
        echo "Install curl to download background images"
        return 1
      fi
    fi
    
    # Count images in the directory
    local img_count=$(ls -1 "$bg_dir" | wc -l | tr -d ' ')
    
    if [[ $img_count -gt 0 ]]; then
      # Select a random image
      local random_num=$((1 + RANDOM % img_count))
      local img_file=$(ls -1 "$bg_dir" | sed -n "${random_num}p")
      
      if [[ -n "$img_file" ]]; then
        # Set the background image using iTerm2's proprietary sequence
        local img_path="$bg_dir/$img_file"
        # Set with 20% opacity for readability
        printf "\033]1337;SetBackgroundImageFile=%s;Opacity=0.2\007" "$(echo -n "$img_path" | base64)"
        echo "Terminal background set to $img_file"
      fi
    fi
  else
    # For non-iTerm terminals, add a hint about how to enable this feature
    echo "Terminal background images require iTerm2 on macOS."
    echo "More info: https://iterm2.com/documentation-images.html"
  fi
}

# Add command to refresh background manually
alias ns-background="set_terminal_background"

# Attempt to set background (will only work on supported terminals)
set_terminal_background >/dev/null 2>&1

# Daily Quote Function
# ----------------
# Fetches a random quote from quotable.io API
get_daily_quote() {
  if command -v curl &> /dev/null; then
    local quote_data=$(curl -s "https://api.quotable.io/random" --connect-timeout 5 2>/dev/null)
    
    if [[ -n "$quote_data" && $(echo "$quote_data" | grep -c "content") -gt 0 ]]; then
      local quote=$(echo "$quote_data" | grep -o '"content":"[^"]*' | cut -d'"' -f4)
      local author=$(echo "$quote_data" | grep -o '"author":"[^"]*' | cut -d'"' -f4)
      
      if [[ -n "$quote" && -n "$author" ]]; then
        echo -e "\033[1;33m\"$quote\"\033[0m"
        echo -e "\033[1;36m— $author\033[0m"
        return 0
      fi
    fi
    
    # Fallback quotes if API fails
    local fallback_quotes=(
      "\"The best way to predict the future is to create it.\"|Abraham Lincoln"
      "\"Quality is not an act, it is a habit.\"|Aristotle"
      "\"The secret of getting ahead is getting started.\"|Mark Twain"
      "\"Success is not final, failure is not fatal: It is the courage to continue that counts.\"|Winston Churchill"
      "\"Code is like humor. When you have to explain it, it's bad.\"|Cory House"
      "\"NetSuite developers don't make bugs, they make undocumented features.\"|Anonymous"
      "\"First, solve the problem. Then, write the code.\"|John Johnson"
    )
    
    local random_quote=${fallback_quotes[$RANDOM % ${#fallback_quotes[@]}]}
    local quote=$(echo "$random_quote" | cut -d'|' -f1)
    local author=$(echo "$random_quote" | cut -d'|' -f2)
    
    echo -e "\033[1;33m$quote\033[0m"
    echo -e "\033[1;36m— $author\033[0m"
  else
    echo "📚 Install curl to enable daily quotes feature."
  fi
}

# Cache quote for the day to avoid repeated API calls
daily_quote_cache() {
  local cache_file="$HOME/.ns_quote_cache"
  local today=$(date +%Y-%m-%d)
  
  # Check if we've already cached a quote today
  if [[ -f "$cache_file" ]] && [[ $(head -1 "$cache_file") == "$today" ]]; then
    # Return cached quote
    tail -n +2 "$cache_file"
  else
    # Get new quote, cache it, and return it
    local quote=$(get_daily_quote)
    echo "$today" > "$cache_file"
    echo "$quote" >> "$cache_file"
    echo "$quote"
  fi
}

# Add visual separator to make the terminal more readable
function ns-sep() {
  echo -e "\n\033[1;34m==================================\033[0m"
  echo -e "\033[1;34m NetSuite Development Environment \033[0m"
  echo -e "\033[1;34m==================================\033[0m\n"
}

# Run separator on new terminal
ns-sep
