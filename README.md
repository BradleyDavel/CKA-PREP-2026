# CKA Practice (Simple Edition)

Straightforward CKA practice labs derived from the CKA-PREP playlist. Every question lives in its own folder with three bash files:

- `LabSetUp.bash` � copy/paste into Killercoda (or any Kubernetes cluster) to prep the environment.
- `Questions.bash` � the scenario text plus the YouTube link for the walkthrough.
- `SolutionNotes.bash` � a step-by-step solution when you need a hint.

## How to Use
1. Launch the CKA Killercoda playground or your own cluster.
2. Clone this repo inside the environment.
3. Pick a folder under `Question-*`.
4. Run `./scripts/run-question.sh Question-01` or cd ~/CKA-PREP-2025-v2
bash scripts/run-question.sh "Question-9 Network-Policy" to apply the setup and print the question text, or run `bash Question-01/LabSetUp.bash` manually.
5. Work through the task, then consult `SolutionNotes.bash` if you need help.

## Available Questions
| Question | Topic | Video |
|----------|-------|-------|
| Question-01 | Install Argo CD using Helm without CRDs | https://youtu.be/8GzJ-x9ffE0 |

More questions can be added by copying the template folder and dropping in the three bash files from the original collection.

## Quick Setup Aliases

```bash
git clone https://github.com/BradleyDavel/CKA-PREP-2026.git

alias q1='cd ~/CKA-PREP-2026 && bash scripts/run-question.sh "Question-1 MariaDB-Persistent volume"'
alias q2='cd ~/CKA-PREP-2026 && bash scripts/run-question.sh "Question-2 ArgoCD"'
alias q3='cd ~/CKA-PREP-2026 && bash scripts/run-question.sh "Question-3 Sidecar"'
alias q4='cd ~/CKA-PREP-2026 && bash scripts/run-question.sh "Question-4 Resource-Allocation"'
alias q5='cd ~/CKA-PREP-2026 && bash scripts/run-question.sh "Question-5 HPA"'
alias q6='cd ~/CKA-PREP-2026 && bash scripts/run-question.sh "Question-6 CRDs"'
alias q7='cd ~/CKA-PREP-2026 && bash scripts/run-question.sh "Question-7 PriorityClass"'
alias q8='cd ~/CKA-PREP-2026 && bash scripts/run-question.sh "Question-8 CNI & Network Policy"'
alias q9='cd ~/CKA-PREP-2026 && bash scripts/run-question.sh "Question-9 Cri-Dockerd"'
alias q10='cd ~/CKA-PREP-2026 && bash scripts/run-question.sh "Question-10 Taints-Tolerations"'
alias q11='cd ~/CKA-PREP-2026 && bash scripts/run-question.sh "Question-11 Gateway-API"'
alias q12='cd ~/CKA-PREP-2026 && bash scripts/run-question.sh "Question-12 Ingress"'
alias q13='cd ~/CKA-PREP-2026 && bash scripts/run-question.sh "Question-13 Network-Policy"'
alias q14='cd ~/CKA-PREP-2026 && bash scripts/run-question.sh "Question-14 Storage-Class"'
alias q15='cd ~/CKA-PREP-2026 && bash scripts/run-question.sh "Question-15 Etcd-Fix"'
alias q16='cd ~/CKA-PREP-2026 && bash scripts/run-question.sh "Question-16 NodePort"'
alias q17='cd ~/CKA-PREP-2026 && bash scripts/run-question.sh "Question-17 TLS-Config"'
```
