# Roadmap

## Weeks 1-2: Network+ foundations
- Lab 1: Diagnostics toolkit
- Lab 2: Subnetting drills (run the script daily until you stop missing questions)
- Lab 3: Packet capture

## Week 3: Network+ security overlap
- Lab 4: Firewall lab

## Weeks 4-5: GRC foundations
- Lab 5: CIS benchmark audit (Lynis)
- Lab 6: Custom audit script
- Lab 7: Framework mapping

## Week 6+: Stretch projects (future GitHub repos/branches)

1. **VLAN simulation with Linux network namespaces** — simulate a segmented
   network entirely in software (`ip netns`) to practice VLAN/subnet
   concepts without needing physical switches.
2. **Automated compliance dashboard** — take the CSV from Lab 6's audit
   script and build a small script (Python + matplotlib, or a static HTML
   page) that renders pass/fail as a visual dashboard. Good portfolio piece.
3. **OpenSCAP + CIS profile** — go beyond Lynis into OpenSCAP's official
   CIS/DISA STIG profiles for a more "enterprise auditor" workflow.
4. **Docker network troubleshooting lab** — since containers are in your
   other learning track, build a lab that intentionally misconfigures
   Docker networking (bad DNS, wrong subnet, blocked port) and practice
   diagnosing it with the same tools from Lab 1.
5. **Incident response tabletop doc** — write a one-page IR runbook for
   "we found this Lynis finding in production" — ties GRC into practical
   response processes, which is often the missing piece in Network+/GRC
   study plans.

## Suggested repo naming
`linux-netsec-grc-labs` or `network-plus-grc-portfolio` — name it something
a recruiter skimming your GitHub would immediately understand.
