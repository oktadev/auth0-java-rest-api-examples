#!/bin/bash

# Check if an app was provided as a command-line argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <app-name>"
  exit 1
fi

# Set the selected app from the command-line argument
selected_app="$1"

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

date_cmd="date"
kill_cmd="fuser -k -n tcp 8080"

if [[ "$OSTYPE" == "darwin"* ]]; then
   gdate --version || echo "gdate is missing. It is used to record timestamps on macOS. Install it using 'brew install coreutils'."
   date_cmd="gdate"
   fkill --version || echo "fkill is missing. Install it using 'npm i -g fkill-cli'."
   kill_cmd="fkill :8080"
fi

# Start the app in the background
$start_command &

# Record the start time in milliseconds
start_time=$(($($date_cmd +%s%N)/1000000))

# Wait for the app to be available on port 8080
while true; do
  # Try to access the app using curl
  if curl -s -o /dev/null http://localhost:8080; then
    # Record the end time in milliseconds
    end_time=$(($($date_cmd +%s%N)/1000000))

    # Calculate the elapsed time in milliseconds
    elapsed_time=$((end_time - start_time))

    # Print the time in milliseconds
    echo "App is available on port 8080. Duration to start: ${elapsed_time} milliseconds"

    $kill_cmd 2> /dev/null || echo "Failed to kill the app running on port 8080."
    break
  fi

  # Sleep for 1 millisecond
  sleep 0.001
done
