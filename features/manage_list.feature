Feature: Manage Pomodoro list
  In order to complete tasks
  As a user
  I want to manage the order and content of my task list

  Scenario: Add tasks
    When I run `pomo add 'Remember the milk'`
    And I run `pomo list`
    Then the output from "pomo list" should contain "Remember the milk"

  Scenario: Add tasks with tomatos
    When I run `pomo add 'Remember the milk' -m 2`
    And I run `pomo list`
    Then the output from "pomo list" should contain "Remember the milk                                  : 2 tomatos"

  Scenario: Remove tasks
    Given the following tasks:
      | Remember the milk |
      | Walk the dog      |
      | Shave the yak     |
    When I run `pomo rm first`
    And I run `pomo list`
    Then the output from "pomo list" should not contain "Remember the milk"

  Scenario: Move tasks
    Given the following tasks:
      | Remember the milk |
      | Walk the dog      |
      | Shave the yak     |
    When I run `pomo mv first last`
    And I run `pomo list`
    Then the output from "pomo list" should contain exactly:
    """
        0. Walk the dog                                       : 25 minutes
        1. Shave the yak                                      : 25 minutes
        2. Remember the milk                                  : 25 minutes
                                                  75 minutes and 0 tomatos

    """

  Scenario: List tasks
    Given the following tasks:
      | Remember the milk |
      | Walk the dog      |
      | Shave the yak     |
    When I run `pomo edit 0 -m 3`
    And I run `pomo list`
    Then the output from "pomo list" should contain exactly:
    """
        0. Remember the milk                                  : 3 tomatos
        1. Walk the dog                                       : 25 minutes
        2. Shave the yak                                      : 25 minutes
                                                  50 minutes and 3 tomatos

    """
