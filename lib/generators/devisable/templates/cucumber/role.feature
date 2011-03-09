Feature: Manage Roles

  Scenario: Viewing Roles as a SuperAdmin
    Given I am signed in as "user@cloudspace.com"
    And I only have the role "SuperAdmin"
    When I go to the roles page
    Then I should see "SuperAdmin"
    And I should see "Show"
    And I should see "Edit"
    And I should see "Destroy"

  Scenario: Viewing Roles as a GeneralUser
    Given I am signed in as "user@cloudspace.com"
    And I only have the role "GeneralUser"
    When I go to the roles page
    Then I should not see "SuperAdmin"
    And I should not see "Show"
    And I should not see "Edit"
    And I should not see "Destroy"

  Scenario: Creating a Role
    Given I am signed in as "user@cloudspace.com"
    And I have the role "SuperAdmin"
    And I am on the roles page
    When I follow "New Role"
    And I fill in "Advanced User" for "Name"
    And I fill in the following checkboxes with categories:
    | category | permission |
    | Roles | manage |
    | Roles | read |
    | Roles | create |
    | Users | manage |
    | Users | read |
    And I press "Create Role"
    Then I should be on that role's view page
    And I should see "Role was successfully created."
    And I should see "Advanced User"

  Scenario: Editing a Role
    Given I am signed in as "user@cloudspace.com"
    And there is only the "SuperAdmin" role in the system
    And I have the role "SuperAdmin"
    And I am on the roles page
    When I follow "Edit"
    And I fill in "SuperDuperAdmin" for "Name"
    And I fill in the following checkboxes with categories:
    | category | permission |
    | Roles | manage |
    | Roles | read |
    | Roles | create |
    | Roles | update | 
    | Roles | destroy |
    | Users | manage |
    | Users | read |
    | Users | create |
    | Users | update | 
    | Users | destroy |
    And I press "Update Role"
    Then I should be on that role's view page
    And I should see "Role was successfully updated."
    And I should see "SuperDuperAdmin"

  Scenario: Deleting a Role
    Given I am signed in as "user@cloudspace.com"
    And the "UnnecessaryRole" role has been added to the system
    And I have the role "SuperAdmin"
    And I am on the roles page
    When I follow "Destroy" for "UnnecessaryRole"
    Then I should be on the roles page
    And I should see "Role was successfully deleted."
    And I should not see "UnnecessaryRole"

  Scenario: Deleting a Role With Users Associated
    Given I am signed in as "user@cloudspace.com"
    And there is only the "SuperAdmin" role in the system
    And I have the role "SuperAdmin"
    And I am on the roles page
    Then I should see a span with the title "Roles with associated users cannot be deleted"

