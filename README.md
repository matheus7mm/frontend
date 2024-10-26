# Car Management App - Frontend

This is a Flutter project for a car management application with a clean and organized architecture, designed to ensure scalability, testability, and maintainability.

## Project Structure

The project is organized into distinct layers to separate concerns and responsibilities:

1. **Application Layer (`config`)**:  
   This layer deals with configurations like dependency injection (`service_locator.dart`) and navigation (`router.dart`). It sets up and manages essential services that the other layers rely on.

2. **Data Layer (`data`)**:  
   Responsible for data handling, this layer communicates directly with external APIs or data sources. It includes:
   - **Datasources**: Classes that interact with APIs or databases to fetch raw data.
   - **Models**: Data structures that represent the response format from the API and convert it to entities used in the app.
   - **Providers**: Contains utilities for configuring and handling API requests:
     - ***DioProvider***: Configures the Dio HTTP client for API requests, supporting both live and mock data environments for testing
     - ***MockApiInterceptor***: A mock interceptor for handling local data and simulating backend responses, allowing offline development and testing flexibility.
   - **Repositories**: Abstractions over data sources, exposing clean methods to the domain layer to interact with data sources.

3. **Domain Layer (`domain`)**:  
   The domain layer defines the core business logic and use cases, ensuring that the app’s functionality aligns with business requirements. It includes:
   - **Entities**: Represent core data models in a business-centric way.
   - **Use Cases**: Define specific actions (for instance, login, fetch cars, ...), encapsulating business logic and interacting with repositories to fetch or manipulate data.

4. **Presentation Layer (`presentation`)**:  
   This layer manages the UI and user interactions, including:
   - **Screens**: The visual representation of the app, where user interaction occurs.
   - **Presenters (BLoCs)**: Handle state management and events, facilitating communication between the UI and the use cases.

Each layer interacts only with the layers directly below or above it, following the principles of Clean Architecture. In each layer/folder, there is a file named after the folder that exports everything within it, making imports into other layers simpler and the structure more organized. Tests are also organized to cover each specific layer.

## Getting Started

This project uses the latest Flutter version: 3.24.3
