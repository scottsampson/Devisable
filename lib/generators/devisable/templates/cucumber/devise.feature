Feature: Devise login and registration

  Scenario: First User Registration
    Given there are no users in the system
    And I have the default roles
    And I am on the sign up page
    When I fill in "user@cloudspace.com" for "Email"
    And I fill in "password" for "Password"
    And I fill in "password" for "Password confirmation"
    And I press "Sign up"
    Then I should be on the homepage
    And I should have the role "SuperAdmin"

  Scenario: Nonfirst User Registration
    Given there are users in the system
    And I have the default roles
    And I am on the sign up page
    When I fill in "user@cloudspace.com" for "Email"
    And I fill in "password" for "Password"
    And I fill in "password" for "Password confirmation"
    And I press "Sign up"
    Then I should be on the homepage
    And I should have the role "GeneralUser"

  Scenario: User Sign In
    Given I am signed in as "user@cloudspace.com"

  Scenario: User Sign Out
    Given I am signed in as "user@cloudspace.com"
    Given I am signed out

  Scenario: User Sign In With Bad Password
    Given I am signed in as "user@cloudspace.com"
    And I am signed out
    And I am on the sign in page
    When I fill in "user@cloudspace.com" for "Email"
    And I fill in "badpass" for "Password"
    And I press "Sign in"
    Then I should be on the sign in page
    And I should see "Invalid email or password"

  Scenario: Lost Password Page
    Given I am signed in as "user@cloudspace.com"
    And I am signed out
    And I am on the forgot password page
    When I fill in "user@cloudspace.com" for "Email"
    And I press "Send me reset password instructions"
    Then I should be on the sign in page
    And I should see "You will receive an email with instructions about how to reset your password in a few minutes."

  Scenario: Lost Password Page Bad Email Address
    Given I am signed in as "user@cloudspace.com"
    And I am signed out
    And I am on the forgot password page
    When I fill in "baduser@cloudspace.com" for "Email"
    And I press "Send me reset password instructions"
    Then I should be on the forgot password submitted page
    And I should see "Email not found"

  Scenario: Lost Password Page Missing Email Address
    Given I am signed in as "user@cloudspace.com"
    And I am signed out
    And I am on the forgot password page
    When I press "Send me reset password instructions"
    Then I should be on the forgot password submitted page
    And I should see "Email can't be blank"

  Scenario: Login Link
    Given I am on the homepage
    When I follow "Login" within "body"
    Then I should be on the sign in page

  Scenario: Logout Link
    Given I am signed in as "user@cloudspace.com"
    And I am on the homepage
    When I follow "Logout"
    And I should be on the homepage
    And I should see "Signed out successfully."
