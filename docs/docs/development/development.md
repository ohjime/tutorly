<!-- Structure of this document
    - Overview
        - Summary of this Section
    - Prerequisites
        - Initial Design Document.
            - The initial design document is the basis of the project and provides a high level overview of the system. Without it, you don't have a formal record of what exactly you are trying to design, and thus your features may become inconsistent or misaligned with the original vision, with overlapping scopes. In that case, when there are conflicts during the sprint planning, it is hard to resolve them without a formal record of what the system was agreed to do.
        - Team has 2-3 developers
            - Sprints which are composed of multiple user stories generally require multiple features to be implemented to complete and satisfy each of its user stories.Since features are designed to be standalone and independent as much as possible, having multiple developers work different features allows for faster development speed without the need for constant communication and collaboration, since the code of one feature does not directly affect the code of another feature. (note: features will effect each other indirectly on the high level, but since their implementation is isolated, bugs are easily identified to what feature they originate from).
    - Development Workflow
        1. Sprint Planning
            - Sprint planning is the process of defining the work to be done in a sprint. It is important to have a clear understanding of what needs to be done in order to avoid confusion and miscommunication during the sprint. This is especially important when working with multiple developers, as it ensures that everyone is on the same page and knows what they need to do. This is where The team will analyze which user stories need to be implemented how many points each story is worth what stories require other stories to be implemented first and then how what are the tasks needed to implement those stories once that is done the team will figure out how to structure each how to implement these features how to implement these tasks into features in the in the code. This is where a thorough review of the design document will be done to ensure the features are aligned with the architecture and backend schema. In Taiga create a bunch of tasks and assign them to the devleopers. 
        2. Create a Branch for each standalone feature needed to be implemented.
            - In VSCode create a new branch for your feature folder.
            - Creating a Github branch for each feature allows for easier tracking of changes and progress. It also allows for easier collaboration between developers, as each developer can work on their own branch without affecting the main codebase. When merging the branches, there should be very little to no conflicts, where the only conflicts that need to be resolved if there are changes to any shared files.
        3. Implement the feature, with testing and documentation.
            - For every file you create in your feature folder there should be a file in the test folder that mirrors in path and name (with a _test suffix) that tests the functionality of the file. Try to do this as you go along, instead of waiting until the end to write all the tests. This will give you better code coverage and also prevent you from over complicating the code with too many files (more files means more testing).
            Make sure to document your code as you go along, this will help you and other developers understand the code better and also help with debugging. Use '\\\' before a function/class/method in order for the documentation to appear in VSCode, and in the geerated docs usign dart doc. Make sure to create documentation for your feature in the feature folder in docs/docs/features/feature_name.md. Use docusarious snippets to customize and structure your page according to how your team decides
        4. Once he feature is completed, make sure to amkrk in Taiga your tasks as ready fro test. Make a pull request to the main branch, and schedule a day to review the merges and their testing.
            - You can either do the integration testing manually or automatically using github actions (trigger on merge) to run flutter integration test suite.
        5. Merge the pull request to the main branch.
            - Once the pull request is approved and all tests have passed, you can merge the pull request to the main branch. This will update the main codebase with your changes and allow other developers to see your work.
            - Documentation will be uploaded autoamtically with the gh_pages workflow, whenever a branch is merged into main.
        6. Demo the main branch either through th eemulator or on a physical device.
            - Start composing your presentations, summaries of your daily sprints and the features you implemented, and what user stories have been completed.
    -Next Section Setup(details on how to get the dev encironment runnning).
-->

# Development Workflow