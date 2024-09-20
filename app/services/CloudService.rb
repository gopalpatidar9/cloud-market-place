# Define a class for Cloud Providers
class CloudService:
    def __init__(self, name, pricing, performance, availability, features, security, support):
        self.name = name
        self.pricing = pricing
        self.performance = performance
        self.availability = availability
        self.features = features
        self.security = security
        self.support = support

# Initialize the cloud services with their scores for each criterion
aws = CloudService("AWS", pricing=8, performance=9, availability=9, features=10, security=9, support=8)
azure = CloudService("Azure", pricing=7, performance=8, availability=10, features=9, security=8, support=9)
gcp = CloudService("GCP", pricing=9, performance=8, availability=9, features=9, security=8, support=7)

# Store all services in a list for comparison
cloud_services = [aws, azure, gcp]

# Define weights for each criterion (make sure they add up to 1 or 100)
weights = {
    "pricing": 0.30,
    "performance": 0.20,
    "availability": 0.20,
    "features": 0.15,
    "security": 0.10,
    "support": 0.05
}

# Function to calculate the total weighted score for a cloud service
def calculate_score(service, weights):
    total_score = (
        service.pricing * weights["pricing"] +
        service.performance * weights["performance"] +
        service.availability * weights["availability"] +
        service.features * weights["features"] +
        service.security * weights["security"] +
        service.support * weights["support"]
    )
    return total_score

# Calculate and print the scores for each cloud service
scores = []
for service in cloud_services:
    score = calculate_score(service, weights)
    scores.append((service.name, score))

# Sort the services based on their total score in descending order
sorted_scores = sorted(scores, key=lambda x: x[1], reverse=True)

# Output the ranking of cloud services
print("Cloud Service Comparison Ranking:")
for idx, (name, score) in enumerate(sorted_scores, start=1):
    print(f"{idx}. {name}: {score:.2f}")

