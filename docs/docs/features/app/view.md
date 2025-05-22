# Component Diagrams for App Views

This document provides an overview of the views (screens/pages) in the `lib/app/view` directory. Each view plays a unique role in the application, and this document explores their relationships, interactions, and behaviors in a conversational manner.

## Component Diagram

```mermaid
flowchart TD
    AppView --> SplashPage
    SplashPage --> WelcomePage
    WelcomePage --> AppView

    subgraph AppView
        direction TB
        AppBloc
    end

    subgraph SplashPage
        direction TB
        CircularProgressIndicator
    end

    subgraph WelcomePage
        direction TB
        AnimatedTextKit
        DelayedDisplay
    end
```

## View Details

### AppView
The `AppView` serves as the backbone of the application. It is responsible for managing navigation and providing the `AppBloc` to the widget tree. This view listens to the `AppBloc` and reacts to its states. For instance, when the user is unauthenticated, the `AppView` navigates to the welcome screen. If onboarding is required, it redirects to the signup page. And finally, if the user is onboarded, it takes them to the home screen. The lifecycle of `AppView` is tightly coupled with the initialization of the `AppBloc`, ensuring that authentication events are handled seamlessly.

#### Sequence Diagram
```mermaid
sequenceDiagram
    participant User
    participant AppView
    participant AppBloc
    participant Navigator

    User->>AppView: Launch App
    AppView->>AppBloc: Dispatch CredentialSubscriptionRequested
    AppBloc->>AppView: Emit Unauthenticated
    AppView->>Navigator: Navigate to /welcome
```

### SplashPage
The `SplashPage` is a simple yet essential part of the application. It provides a loading indicator while the app initializes. Although it does not interact with any blocs, its primary role is to offer visual feedback to the user during the initialization phase. Once the initialization is complete, the `SplashPage` navigates to the `WelcomePage`. This view is stateless, making it lightweight and efficient.

#### Sequence Diagram
```mermaid
sequenceDiagram
    participant App
    participant SplashPage
    participant Navigator

    App->>SplashPage: Initialize
    SplashPage->>Navigator: Navigate to WelcomePage
```

### WelcomePage
The `WelcomePage` is the first point of interaction for unauthenticated users. It is designed to captivate users with branding and animations, creating a memorable first impression. This view does not listen to any blocs but uses animations like `AnimatedTextKit` and `DelayedDisplay` to enhance user engagement. When the user interacts with the `WelcomePage`, such as tapping the "Get Started" button, it navigates back to the `AppView`.

#### Sequence Diagram
```mermaid
sequenceDiagram
    participant User
    participant WelcomePage
    participant Navigator

    User->>WelcomePage: Tap Get Started
    WelcomePage->>Navigator: Navigate to AppView
```
