class CloudServicesController < ApplicationController
  before_action :authenticate_user!
  
  def compare
    monthly_users = params[:monthly_users].to_i
    service_duration = params[:service_duration].to_i
    security_level = params[:security_level]

    best_service_details = determine_best_service(monthly_users, service_duration, security_level)

    render :partial => 'comparison_result', locals: { best_service: best_service_details }
  end

  def compare_remote_sql
    if request.post?
      required_storage = params[:storage].to_i
      performance = params[:performance]
      budget = params[:budget].to_f
  
      suitable_providers = PROVIDERS.select do |provider|
        provider[:service_type] == "SQL Database" &&
        provider[:performance_tier] == performance &&
        provider[:supports_backups]
      end
  
      within_budget_providers = suitable_providers.select do |provider|
        provider[:storage_cost_per_gb] * required_storage <= budget
      end
  
      @best_provider = if within_budget_providers.any?
                         within_budget_providers.min_by { |provider| provider[:storage_cost_per_gb] * required_storage }
                       elsif suitable_providers.any?
                         suitable_providers.min_by { |provider| provider[:storage_cost_per_gb] * required_storage }
                       else
                         PROVIDERS.first
                       end
  
      @estimated_cost = @best_provider[:storage_cost_per_gb] * required_storage if @best_provider
    end
  end
  
  
  def custom_requirements
    @services = PREDEFINED_SERVICES
  end

  def index
    @services = {
      compute: [
        { id: 1, service: "Azure cloud", service_type: "COMPUTE", service_name: "Azure Virtual Machines (VMs)", service_description: "Provides on-demand scalable virtualized computing resources, similar to Amazon EC2 in AWS." },
        { id: 2, service: "Azure cloud", service_type: "COMPUTE", service_name: "Azure App Service", service_description: "A fully managed platform for building, deploying, and scaling web apps. It supports .NET, Java, Node.js, Python, and more." },
      ],
      storage: [
        { id: 1, service: "Azure cloud", service_type: "STORAGE", service_name: "Azure Blobs", service_description: "A massively scalable object store for text and binary data. Also includes support for big data analytics through Data Lake Storage Gen2." },
        { id: 2, service: "Azure cloud", service_type: "STORAGE", service_name: "Azure Files", service_description: "Managed file shares for cloud or on-premises deployments." },
      ]
    }
  end

  private

  def determine_best_service(monthly_users, service_duration, security_level)
    services = {
      "AWS" => {
        name: "AWS",
        platform_services: {
          "S3" => { price_per_month: 100, security: "high", description: "AWS S3 storage service." },
          "EC2" => { price_per_month: 150, security: "high", description: "AWS EC2 compute instances." },
          "RDS" => { price_per_month: 200, security: "high", description: "AWS RDS database service." },
          "Lambda" => { price_per_month: 50, security: "high", description: "AWS Lambda for serverless computing." },
          "DynamoDB" => { price_per_month: 120, security: "high", description: "AWS NoSQL database service." }
        },
        description: "Amazon Web Services offers a highly reliable, scalable, and low-cost cloud infrastructure."
      },
      
      "Azure" => {
        name: "Azure",
        platform_services: {
          "Blob Storage" => { price_per_month: 90, security: "standard", description: "Azure Blob Storage service." },
          "VMs" => { price_per_month: 130, security: "standard", description: "Azure Virtual Machines." },
          "SQL Database" => { price_per_month: 150, security: "standard", description: "Azure SQL Database service." },
          "Azure Functions" => { price_per_month: 70, security: "standard", description: "Azure Functions for serverless computing." },
          "Cosmos DB" => { price_per_month: 110, security: "high", description: "Azure Cosmos DB NoSQL database service." }
        },
        description: "Microsoft Azure provides cloud services for building, testing, deploying, and managing applications."
      },
      
      "GCP" => {
        name: "Google Cloud Platform",
        platform_services: {
          "Cloud Storage" => { price_per_month: 80, security: "basic", description: "GCP Cloud Storage service." },
          "Compute Engine" => { price_per_month: 120, security: "basic", description: "GCP Compute Engine service." },
          "Cloud SQL" => { price_per_month: 180, security: "basic", description: "GCP Cloud SQL service." },
          "Cloud Functions" => { price_per_month: 60, security: "basic", description: "GCP Cloud Functions for serverless computing." },
          "Firestore" => { price_per_month: 100, security: "standard", description: "GCP Firestore NoSQL database service." }
        },
        description: "Google Cloud Platform provides a suite of cloud computing services that runs on the same infrastructure that Google uses internally."
      },
    
      "IBM Cloud" => {
        name: "IBM Cloud",
        platform_services: {
          "Cloud Object Storage" => { price_per_month: 85, security: "standard", description: "IBM Cloud Object Storage service." },
          "Virtual Servers" => { price_per_month: 120, security: "standard", description: "IBM Cloud Virtual Servers." },
          "Db2" => { price_per_month: 150, security: "standard", description: "IBM Db2 SQL Database service." },
          "IBM Cloud Functions" => { price_per_month: 50, security: "high", description: "IBM Cloud Functions for serverless computing." },
          "Cloudant" => { price_per_month: 110, security: "high", description: "IBM Cloudant NoSQL database service." }
        },
        description: "IBM Cloud includes infrastructure as a service (IaaS), platform as a service (PaaS), and software as a service (SaaS) offered through public, private, and hybrid cloud delivery models."
      },
    
      "DigitalOcean" => {
        name: "DigitalOcean",
        platform_services: {
          "Spaces" => { price_per_month: 50, security: "basic", description: "DigitalOcean Spaces storage service." },
          "Droplets" => { price_per_month: 75, security: "standard", description: "DigitalOcean Droplets for compute." },
          "Managed Databases" => { price_per_month: 130, security: "high", description: "DigitalOcean Managed Databases for PostgreSQL, MySQL, and Redis." },
          "Functions" => { price_per_month: 40, security: "basic", description: "DigitalOcean Functions for serverless computing." }
        },
        description: "DigitalOcean provides developers with cloud services that help to deploy and scale applications."
      },
    
      "Heroku" => {
        name: "Heroku",
        platform_services: {
          "Heroku Postgres" => { price_per_month: 100, security: "standard", description: "Heroku managed PostgreSQL database." },
          "Heroku Redis" => { price_per_month: 75, security: "standard", description: "Heroku managed Redis service." },
          "Heroku App Platform" => { price_per_month: 150, security: "standard", description: "Heroku App Platform for hosting applications." }
        },
        description: "Heroku is a platform as a service (PaaS) that enables developers to build, run, and operate applications entirely in the cloud."
      },
    
      "Alibaba Cloud" => {
        name: "Alibaba Cloud",
        platform_services: {
          "Object Storage" => { price_per_month: 70, security: "high", description: "Alibaba Cloud Object Storage service." },
          "ECS" => { price_per_month: 100, security: "high", description: "Alibaba Cloud Elastic Compute Service." },
          "RDS" => { price_per_month: 160, security: "high", description: "Alibaba Cloud RDS database service." },
          "Function Compute" => { price_per_month: 55, security: "high", description: "Alibaba Cloud Function Compute for serverless." },
          "NoSQL Database" => { price_per_month: 90, security: "standard", description: "Alibaba Cloud NoSQL Database." }
        },
        description: "Alibaba Cloud is the cloud computing arm and a subsidiary of Alibaba Group, providing a comprehensive suite of cloud services."
      }
    }

    best_service = nil
    lowest_cost = Float::INFINITY
    best_platform_service = nil

    services.each do |name, details|
      details[:platform_services].each do |service_name, service_details|
        estimated_cost = calculate_cost(service_details[:price_per_month], service_duration, monthly_users)

        if valid_security?(service_details[:security], security_level) && estimated_cost < lowest_cost
          lowest_cost = estimated_cost
          best_service = { platform: name, service_name: service_name, price: estimated_cost, security: service_details[:security], description: service_details[:description] }
        end
      end
    end

    best_service || { error: "No suitable service found" }
  end

  def calculate_cost(price_per_month, duration, monthly_users)
    base_cost = price_per_month * duration
    user_cost_factor = 0.1 * monthly_users 
    base_cost + user_cost_factor
  end

  def valid_security?(service_security, user_security)
    security_levels = { "basic" => 1, "standard" => 2, "high" => 3 }
    security_levels[service_security] >= security_levels[user_security]
  end

  PROVIDERS = [
    # AWS Services
    {
      name: "AWS RDS",
      service_type: "SQL Database",
      storage_cost_per_gb: 0.12,
      performance_tier: "high",
      supports_backups: true,
      other_features: ["Multi-AZ", "Encryption"]
    },
    {
      name: "AWS S3",
      service_type: "Storage",
      storage_cost_per_gb: 0.023,
      performance_tier: "high",
      supports_backups: true,
      other_features: ["Versioning", "Lifecycle Policies"]
    },
    {
      name: "AWS EC2",
      service_type: "Compute",
      storage_cost_per_gb: 0.10,
      performance_tier: "high",
      supports_backups: false,
      other_features: ["Elastic IP", "Auto-Scaling"]
    },
  
    # Google Cloud Services
    {
      name: "Google Cloud SQL",
      service_type: "SQL Database",
      storage_cost_per_gb: 0.10,
      performance_tier: "standard",
      supports_backups: true,
      other_features: ["Auto-Scaling", "Encryption"]
    },
    {
      name: "Google Cloud Storage",
      service_type: "Storage",
      storage_cost_per_gb: 0.020,
      performance_tier: "standard",
      supports_backups: true,
      other_features: ["Versioning", "Class A and B Storage"]
    },
    {
      name: "Google Compute Engine",
      service_type: "Compute",
      storage_cost_per_gb: 0.06,
      performance_tier: "high",
      supports_backups: false,
      other_features: ["Auto-Scaling", "Load Balancing"]
    },
  
    # Azure Services
    {
      name: "Azure SQL Database",
      service_type: "SQL Database",
      storage_cost_per_gb: 0.15,
      performance_tier: "high",
      supports_backups: true,
      other_features: ["Geo-Replication", "Automatic Tuning"]
    },
    {
      name: "Azure Blob Storage",
      service_type: "Storage",
      storage_cost_per_gb: 0.02,
      performance_tier: "standard",
      supports_backups: true,
      other_features: ["Versioning", "Lifecycle Management"]
    },
    {
      name: "Azure Virtual Machines",
      service_type: "Compute",
      storage_cost_per_gb: 0.12,
      performance_tier: "standard",
      supports_backups: false,
      other_features: ["Auto-Scaling", "Load Balancer"]
    },
  
    # IBM Cloud Services
    {
      name: "IBM Db2",
      service_type: "SQL Database",
      storage_cost_per_gb: 0.14,
      performance_tier: "high",
      supports_backups: true,
      other_features: ["High Availability", "Encryption"]
    },
    {
      name: "IBM Cloud Object Storage",
      service_type: "Storage",
      storage_cost_per_gb: 0.03,
      performance_tier: "standard",
      supports_backups: true,
      other_features: ["Versioning", "Lifecycle Policies"]
    },
    {
      name: "IBM Cloud Virtual Servers",
      service_type: "Compute",
      storage_cost_per_gb: 0.10,
      performance_tier: "high",
      supports_backups: false,
      other_features: ["Auto-Scaling", "Load Balancing"]
    },
  
    # Alibaba Cloud Services
    {
      name: "Alibaba Cloud RDS",
      service_type: "SQL Database",
      storage_cost_per_gb: 0.16,
      performance_tier: "high",
      supports_backups: true,
      other_features: ["High Availability", "Auto-Scaling"]
    },
    {
      name: "Alibaba Cloud Object Storage",
      service_type: "Storage",
      storage_cost_per_gb: 0.04,
      performance_tier: "standard",
      supports_backups: true,
      other_features: ["Versioning", "Data Security"]
    },
    {
      name: "Alibaba Cloud ECS",
      service_type: "Compute",
      storage_cost_per_gb: 0.08,
      performance_tier: "standard",
      supports_backups: false,
      other_features: ["Elastic IP", "Auto-Scaling"]
    },
  
    # DigitalOcean Services
    {
      name: "DigitalOcean Managed Databases",
      service_type: "SQL Database",
      storage_cost_per_gb: 0.15,
      performance_tier: "high",
      supports_backups: true,
      other_features: ["High Availability", "Auto-Scaling"]
    },
    {
      name: "DigitalOcean Spaces",
      service_type: "Storage",
      storage_cost_per_gb: 0.02,
      performance_tier: "standard",
      supports_backups: true,
      other_features: ["Versioning", "Data Security"]
    },
    {
      name: "DigitalOcean Droplets",
      service_type: "Compute",
      storage_cost_per_gb: 0.09,
      performance_tier: "high",
      supports_backups: false,
      other_features: ["Elastic IP", "Load Balancing"]
    },
  
    # Heroku Services
    {
      name: "Heroku Postgres",
      service_type: "SQL Database",
      storage_cost_per_gb: 0.12,
      performance_tier: "standard",
      supports_backups: true,
      other_features: ["High Availability", "Auto-Scaling"]
    },
    {
      name: "Heroku Redis",
      service_type: "Storage",
      storage_cost_per_gb: 0.15,
      performance_tier: "standard",
      supports_backups: true,
      other_features: ["Data Persistence", "High Availability"]
    },
  
  ].freeze

  PREDEFINED_SERVICES = [
    {
      'id' => '0',
      'title' => 'Store user profile image and retrieve profile image.',
      'details' => {
        'csp_name' => 'Amazon Web Service',
        'service_name' => 'S3',
        'price' => '1.0 USD'
      }
    },
    {
      'id' => '1',
      'title' => 'Store all students marksheet as a PDF and retrieve when it required.',
      'details' => {
        'csp_name' => 'Amazon Web Service',
        'service_name' => 'S3',
        'price' => '1.0 USD'
      }
    },
    {
      'id' => '2',
      'title' => 'Compute resources for hosting web applications and APIs.',
      'details' => {
        'csp_name' => 'Google Cloud Platform',
        'service_name' => 'Compute Engine',
        'price' => '10.0 USD per month'
      }
    },
    {
      'id' => '3',
      'title' => 'Store all user-generated content (videos, images, documents).',
      'details' => {
        'csp_name' => 'Microsoft Azure',
        'service_name' => 'Blob Storage',
        'price' => '0.02 USD per GB'
      }
    },
    {
      'id' => '4',
      'title' => 'Host databases for user authentication and content management.',
      'details' => {
        'csp_name' => 'IBM Cloud',
        'service_name' => 'Db2',
        'price' => '0.15 USD per GB'
      }
    },
    {
      'id' => '5',
      'title' => 'Store logs and metrics for monitoring and debugging purposes.',
      'details' => {
        'csp_name' => 'Alibaba Cloud',
        'service_name' => 'Log Service',
        'price' => '0.01 USD per GB'
      }
    }
  ]
  
end
