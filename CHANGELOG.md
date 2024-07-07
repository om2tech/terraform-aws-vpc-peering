# terraform-aws-vpc-peering

Terraform module to create a VPC peering between two VPCs.

## Usage

There are 3 major use-cases to this module.
1. Create a VPC peering between two VPCs in the same account an in the same region.
2. Create a VPC peering between two VPCs in the same account but in different regions.
3. Create a VPC peering between two VPCs in different accounts (region non-specific).

The first use-case can be acheived in the same workspace.
Both the second and third use-cases require the use of two separate workspaces.
One workspace for the requester region/account and the other for the region/accepter account.

| Name                      | Required | Descriptios                                                                                                                                                                                                                                                             | Default       | Options                        |
| ------------------------- | -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------- | ------------------------------ |
| changelog_type            | No       | pull_request option will generate changelog using pull request title. commit_message option will generate changelog using commit messages.                                                                                                                              | pull_request  | pull_request or commit_message |
| header_prefix             | No       | The prefix before the version number. e.g. version: in Version: 1.0.2                                                                                                                                                                                                   | Version:      |                                |
| commit_changelog          | No       | If it's set to true then Changelog CI will commit the changes to the release pull request. (A pull Request will be created with the changes if the workflow run is not triggered by a pull_request event)                                                               | true          | true or false                  |
| comment_changelog         | No       | If it's set to true then Changelog CI will comment the generated changelog on the release pull request. (Only applicable for workflow runs triggered by a pull_request event)                                                                                           | false         | true or false                  |
| pull_request_title_regex  | No       | If the pull request title matches with this regex Changelog CI will generate changelog for it. Otherwise, it will skip the changelog generation. (Only applicable for workflow runs triggered by a pull_request event)                                                  | ^(?i:release) |                                |
| version_regex             | No       | This regex is used to find the version name/number (e.g. 1.0.2, v2.0.2) from the pull request title. in case of no match, changelog generation will be skipped. (Only applicable for workflow runs triggered by a pull_request event)                                   | SemVer        |                                |
| group_config              | No       | By adding this you can group changelog items by your repository labels with custom titles.                                                                                                                                                                              | null          |                                |
| include_unlabeled_changes | No       | if set to false the generated changelog will not contain the Pull Requests that are unlabeled or the labels are not on the group_config option. This option will only be used if the group_config option is added and the changelog_type option is set to pull_request. | true          | true or false                  |
| unlabeled_group_title     | No       | This option will set the title of the unlabeled changes. This option will only be used if the include_unlabeled_changes option is set to true, group_config option is added and the changelog_type option is set to pull_request.                                       | Other Changes |                                |
