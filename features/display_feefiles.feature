Feature: Manage feefiles
  In order to show the contents of a loaded feefile
  user 
  wants to be display it
  


  Scenario: display feefile
    Given I am on the feefiles page
    Given the following feefiles:
      |feefilename|
      |test1|
      |test2|
      |test3|
      |test4|
      |test5|
    When I show the 3rd feefile
    Then I should see the following feefiles:
     |Feefilename|
      |test1|
      |test2|
      |test4|
      |test5|