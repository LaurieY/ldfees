Feature: Manage feefiles
  In order to reduce the loaded feefiles
  user 
  wants to be able to delete one
  


  Scenario: Delete feefile
    Given I am on the feefiles page
    Given the following feefiles:
      |feefilename|
      |test1|
      |test2|
      |test3|
      |test4|
      |test5|
    When I delete the 3rd feefile
    Then I should see the following feefiles:
     |Feefilename|
      |test1|
      |test2|
      |test4|
      |test5|