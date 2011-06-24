Feature: Manage users

  Scenario: Managing Users as a SuperAdmin
    Given I am signed in as "user@cloudspace.com"
    And I only have the role "SuperAdmin"
    When I go to the users page
    Then I should see "user@cloudspace.com"
    And I should see "SuperAdmin"
    And I should see "Edit"
    And I should see "Delete"

  Scenario: Managing Users as a GenericUser
    Given I am signed in as "user@cloudspace.com"
    And I only have the role "GeneralUser"
    When I go to the users page
    When I should be on the homepage
    And I should see "You are not authorized to access this page."

  Scenario: Editing a User
    Given I am signed in as "user@cloudspace.com"
    And I have the role "SuperAdmin"
    And there are users in the system
    When I go to the other user's edit page
    And I check "GeneralUser"
    And I fill in "password" for "Password"
    And I fill in "password" for "Password confirmation"
    And I press "Submit"
    Then I should be on that user's view page
    And I should see "The account has been updated"

  Scenario: Deleting a User
    Given I am signed in as "user@cloudspace.com"
    And I have the role "SuperAdmin"
    And there are users in the system
    And I am on the users page
    When I delete the other user
    Then I should be on the users page
    And I should see "The account has been deleted"

  Scenario: Deleting Self
    Given I am signed in as "user@cloudspace.com"
    And there is only the "SuperAdmin" role in the system
    And I have the role "SuperAdmin"
    And I am on the users page
    Then I should see a span with the title "Can NOT delete the last SuperAdmin user"