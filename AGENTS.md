# Agent Instructions

Before starting any task in this repository:

1. Run `make agents/sync`. It writes the shared Plus3 IT instructions for this repository's tardigrade-ci version to `.agents/plus3it/AGENTS.md`.
2. Read `.agents/plus3it/AGENTS.md` and follow it together with this file. If the sync fails, tell the user, and don't guess the conventions.

These rules always apply, even without the shared instructions:

- Don't push, open pull requests, publish releases, or apply infrastructure changes unless the user asks. List those steps for a person in your final report.
- Don't edit files under `.agents/plus3it/`; they are generated and overwritten by the sync.

@.agents/plus3it/AGENTS.md

## Repository-specific

### Purpose

This Terraform module creates a private NAT Gateway (`connectivity_type = "private"`). The main input is the `nat_gateway` object: it takes either an existing `subnet_id` or a `subnet` to create, and can also create a route table (with an association to the subnet) and routes, where `"self"` refers to the new route table or NAT Gateway. It outputs the created resources as `nat_gateway`, `subnet`, `route_table`, `route_table_association`, and `routes`.
