@feature_search
Feature: Search Feature

  Background:
    Given agree chrome terms
    And refuse account sync

  @search @smoke
  Scenario: Search successfully
    When search "kloia" on home page
    Then verify search result contains searched keyword on search result page