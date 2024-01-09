#!/bin/bash

# Check if an access token and app were provided as command-line arguments
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <access-token> <app-name>"
  exit 1
fi

# Set the selected app and access token from the command-line arguments
access_token="$1"
selected_app="$2"

# Define the start commands for different apps using a case statement
case "$selected_app" in
  "micronaut")
    start_command="./micronaut/build/native/nativeCompile/app"
    ;;
  "micronaut-optimized")
    start_command="./micronaut/build/native/nativeOptimizedCompile/app"
    ;;
  "quarkus")
    start_command="./quarkus/build/quarkus-1.0.0-SNAPSHOT-runner"
    ;;
  "spring-boot")
    start_command="./spring-boot/build/native/nativeCompile/spring-boot"
    ;;
  "helidon")
    start_command="./helidon/target/helidon"
    ;;
  # Add more cases for other apps as needed
  *)
    echo "Selected app is not found in the options map."
    exit 1
    ;;
esac

# Extract the executable name using basename
executable=$(basename "$start_command")

# Define memory function
memory() {
  ps -o pid,rss,command | grep $1 | awk '{$2=int($2/1024)"M";}{ print;}'
}

kill_cmd="fuser -k -n tcp 8080"

if [[ "$OSTYPE" == "darwin"* ]]; then
   fkill --version || echo "fkill is missing. Install it using 'npm i -g fkill-cli'."
   kill_cmd="fkill :8080"
fi

# Start the app in the background
$start_command &

# Wait for the app to be available on port 8080
while true; do
  # Try to access the app using curl
  if curl -s -o /dev/null http://localhost:8080; then
    # Print out memory usage after startup
    echo -e "\n---- Memory usage after startup:"
    memory $executable

    # Make a curl request with an access token
    curl -s -o /dev/null localhost:8080/hello -i --header "Authorization: Bearer $access_token"

    # Print out memory usage after first request
    echo -e "\n---- Memory usage after the first request:"
    memory $executable

    # Make 9 more curl requests with an access token
    for ((i=1; i<=9; i++)); do
      curl -s -o /dev/null localhost:8080/hello -i --header "Authorization: Bearer $access_token"
    done

    # Print out memory usage after 10 requests
    echo -e "\n---- Memory usage after 10 requests:"
    memory $executable

    # Kill the app
    $kill_cmd 2> /dev/null || echo "Failed to kill the app running on port 8080."

    break
  fi

  # Sleep for 1 millisecond
  sleep 0.001
done
