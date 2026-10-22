# An Open-Source Quality Management System

## 1. Executive Summary
- todo

## 2. The Problem

### 2.1 The Reproducibility Crisis

Academia is struggling with a reproducibility crisis.  Published estimates of
irreproducibility range from 51% [@hartshorne2012tracking] to 89%
[@begley2012raise] and it is estimated that irreproducible preclinical research
wastes approximately 28 billion dollars a year in the US alone
[@freedman2015economics].

Many of the systemic causes of irreproducibility can ultimately be traced to an
underlying lack of a standards and best practices framework
[@freedman2015economics; @global2013case] or to poor data management
[@soundararajan2023data].  Additionally, while academia has peer review for
*results*, it rarely peer reviews *process*.

### 2.2 The Translation Gap

Furthermore, translating validated and reproducible results into the clinic is
a daunting and difficult task, known as "the valley of death"
[@coller2009traversing].

Academic institutions lack the experience and infrastructure needed to produce
regulated products, or evidence supporting them, in a regulatory-compliant
manner [@coller2009traversing; @stamler2003].

Data are assessed for fitness for use and reliability before they can inform a
regulatory decision, and protocols and analysis plans are expected to be
finalized before analyses are conducted [@fda2023rwe]. Consequently, data
originating in academia which have not been generated under prospectively
defined and documented procedures cannot serve as the primary basis for a
determination of substantial evidence [@cfr314.126].  At best they can provide
corroborative support, and only where they are "carefully conducted and
documented". Reports lacking the details that permit scientific evaluation are
not considered at all [@cfr314.126].

### 2.3 The Shared Root Cause

The reproducibility crisis and the translation gap are usually treated as
separate problems, but they share a root cause.  Reproducibility is a question
of *internal repeatability*: can the work be repeated, by the same lab or
another, and produce the same result?  Translatability is a question of
*external acceptability*: can someone outside the lab, such as a sponsor or a
regulator, trust how the work was done well enough to rely on it?  Both depend
on research being conducted under defined, documented and controlled
processes.  They are the same requirement viewed from different directions.

A lack of consistent research quality systems is one of the systemic causes of
irreproducibility, and there are few standards for quality management in life
science research [@global2013case].  Standards are expected to make research
outcomes "credible, reproducible, and translatable" alike [@global2013case],
and the FDA encourages sponsors to take a risk-based quality management
approach to study oversight [@fda2023rwe].

Therefore one set of controls can serve both ends.  Standard quality management
processes such as document control, versioning, risk management, corrective and
preventive action (CAPA), and change control make research repeatable inside
the lab, and they produce the documented record that a sponsor or regulator
needs to see from outside it.

### 2.4 The Cost Barrier

Even where academic institutions recognize the need for a quality system, the
cost of establishing one is often prohibitive.  Historically, academia has not
had dedicated quality assurance personnel and has had difficulty funding these
positions [@adamo2014options].  Academic laboratories face a "lack of funding
for compliance costs" and high staff turnover due to a dependence on students
as temporary personnel [@timoteo2021digital; @littrell2020costs].  As a
result, the cost of implementing quality management is often a deterrent
[@littrell2020costs].

The published figures bear this out.  The University of Kentucky estimates
that building its GLP-compliant infrastructure cost $623,000 over three years,
nearly half of which went to gap analyses, external consulting and training
[@littrell2020costs].

Commercial electronic QMS (eQMS) software adds to these costs.  Vendors rarely
publish prices, but licenses typically run to tens of thousands of dollars a
year even for a small team, and the software arrives as a largely empty,
configurable platform.  The SOPs, forms and workflows that make it a quality
system must still be written, configured and validated, usually by consultants
at additional cost.

Investment in quality is not wasted.  At the University of Kentucky,
industry-funded research more than doubled after the quality system was
established, and annual maintenance fell to about 9% of the initial cost
[@littrell2020costs].  But the investment comes up front, and few academic labs
can absorb it.  Quality systems therefore remain largely confined to industry
and a small number of well-funded academic facilities.

## 3. The Solution

We propose a free, lightweight, open-source quality management system for
academic research, built on git, the version-control system researchers already
use for code.  Because the controls that make research reproducible are the same
controls that make it submission-ready, a single QMS can address both the
reproducibility crisis and the translation gap.

## 4. The Benefits of an Open-Source QMS

Not only does an open-source QMS remove the licensing costs, it also changes
how the QMS is built, maintained, and trusted.

### 4.1 Eliminating Duplicated Effort

Today, an institution that needs a QMS largely builds its own.  Each one
commissions its own gap analysis, engages its own consultants, and writes its
own SOPs, forms and workflows.  At the University of Kentucky, nearly half of
the initial cost of its GLP-compliant infrastructure went to gap analyses,
external consulting and training [@littrell2020costs], and every other
institution must pay for the same work.  Yet the result is largely the same
from one site to the next: the regulations being met are the same, and so are
most of the controls needed to meet them.  The cost of building a QMS is paid
many times over for what is essentially the same artifact.

Commercial eQMS vendors do not remove this duplication.  They monetize it.  As
described in Section 2.4, each customer pays for a largely empty platform and
then pays again to have it filled with SOPs, forms and workflows much like
those every other customer has already paid for.

Sharing what has already been built inverts this paradigm.  The University of
Kentucky's Good Research Practice Resource Center, for example, provides
templates for building a quality management system through consultation and
training with the researchers it supports [@littrell2020costs].  An
open-source QMS extends that model beyond a single institution.  The core is
written once, maintained collectively, and adapted locally, so each new site
starts from a working system rather than a blank page.

### 4.2 Best Practices Become Reviewable and Contestable

Today, the knowledge of how to interpret regulations and turn them into
working controls is largely tacit.  It lives in the heads of experienced
quality staff and in the files of individual institutions, and it is most
often obtained by hiring consultants.  At the University of Kentucky, the GLP
implementation relied on "specialized external consultants who have
regulatory expertise" [@littrell2020costs].  The resulting interpretations are
rarely published, so they cannot be compared, cited, or challenged.

A public repository changes this.  Every SOP, and every interpretation it
embodies, is visible to anyone.  Each version is recorded, so a site can cite
exactly which version it adopted.  Anyone can raise a concern or propose an
improvement, and the discussion is recorded alongside the change it led to.
Interpretations that are wrong or outdated can be challenged in the open
rather than repeated in private.

This is peer review applied to *process*, which Section 2.1 noted academia
rarely has.  It is also how successful shared standards have been built
before.  The World Wide Web Consortium and the Internet Engineering Task Force
steered competing organizations toward common standards through open,
collaborative work, and the life sciences need a similar "dynamic,
collaborative effort to standardize common scientific processes"
[@freedman2015economics].  An open-source QMS gives the field a framework for
that work, and a way to converge over time on best practices the community as
a whole has reviewed and vetted.

### 4.3 Rationale Is Preserved, Not Just the Requirement

Boilerplate SOPs record what must be done.  They rarely record why.  The
reasoning behind a control, such as the regulation it answers, the
alternatives that were rejected, or the problem it was written to fix, usually
lives only in the memory of the people who wrote it.  In academia, where staff
turnover is high (Section 2.4), those people are often gone within a few
years, and the reasoning goes with them.  The control then becomes something
to follow without understanding, or to quietly drop.

A QMS built on git keeps that reasoning.  Every change is recorded with who
made it, when, and why, and the discussion that led to it stays linked to the
change itself.  The same applies to the QMS's own reviews.  Gap analyses, the
findings they raise, and the remediations that close them become part of the
public record rather than a report filed away and forgotten.

This matters for audits as well as for continuity.  Regulators expect changes
to be explained, not just made.  FDA guidance, for example, asks that
revisions to a study protocol be "date-stamped," with "the rationale for each
change" provided [@fda2023rwe].  A QMS that carries its own reasoning can
answer the question that both an auditor and a new staff member will
eventually ask.  Why do we do it this way?

### 4.4 Network Effects

Each site that adopts a common QMS makes it more valuable to every other site.

For sponsors and regulators, a shared framework means evaluating one QMS
rather than many.  Today, a sponsor considering an academic partner, or data
generated in academia, must assess each institution's quality system on its
own terms.  If sites share a common, public QMS, the sponsor can review it
once and then focus on how each site has adapted and followed it.  The
University of Kentucky reports that having "a QM framework familiar to the
pharmaceutical/device industry" broadened its industry collaborations
[@littrell2020costs].  A QMS shared across many institutions extends that
familiarity, which directly narrows the translation gap described in
Section 2.2.

For multi-site studies, a shared QMS means sites start from the same
procedures.  Irreproducibility fundamentally "stems from undefined variance in
reagents, practices, and assays between laboratories" [@global2013case].
Sites that follow the same documented procedures remove one source of that
variance by default, rather than negotiating common procedures for each new
collaboration.

These benefits compound.  Every site that adopts the QMS adds to the pool of
reviewers, contributors and evidence that it works, and makes the QMS more
attractive to the next site.  With a commercial eQMS, each new customer adds
revenue for the vendor but nothing for other customers.  With an open-source
QMS, every new adopter increases its value to all the others.

### 4.5 A Teaching Artifact

Academic investigators often "lack experience in drug development and
regulatory processes" [@coller2009traversing], and there are few accessible
ways to gain it.  Regulations and standards are written for compliance, not
instruction, and the working QMSs that show how they are applied in practice
are held privately by the companies and institutions that built them.

An open-source QMS is readable by anyone.  A student or new investigator can
see how an abstract requirement becomes a concrete procedure, form and record,
and, through the history described in Section 4.3, why it was written that
way.  Because it can be copied and modified freely, it can also be practiced
on.  A lab can trial a procedure, or a course can build exercises around it,
without any risk to a live quality system.

Academia is, above all, a training environment.  The high staff turnover that
makes quality systems hard to sustain is "inherent to the training environment
of academia" [@littrell2020costs], which also means a steady stream of
students and trainees passes through every lab.  Institutions that conduct
regulated research already value the opportunity "to teach students, staff,
and faculty how to perform regulated research" [@adamo2014options].  An
open-source QMS lets every institution offer that, whether or not it runs
regulated studies, and sends trainees on to their next position already
literate in quality management.

### 4.6 Extensibility Across Domains

Most of a QMS is not specific to any one kind of research.  Document control,
change control, training records, CAPA and internal audit work the same way
whether a lab is running an observational study or developing software.  The
QMS is therefore structured as a domain-agnostic core, with domain-specific
overlays that add the procedures, forms and regulatory mappings a particular
field needs.  A new domain does not need a new QMS, only a new overlay.

The two domains already built, software medical devices and observational
studies (Section 6), are quite different from each other, which suggests the
core generalizes.  Candidate future domains include imaging core facilities,
biobanks, AI/ML model development and wet-lab protocols, each of which faces
reproducibility and quality pressures of its own.

Medical device startups are a particularly natural extension.  Many begin as
academic spinouts, carrying a discovery out of the lab and into the valley of
death described in Section 2.2.  Discoveries made at academic medical centers
are typically handed to industry for development, yet "early stage
(biotechnology) entities often are poorly suited to this task"
[@stamler2003].  A device company generally needs a QMS aligned with ISO 13485
to bring a product to market, and it needs one at the point when it can least
afford one.  The existing software medical device QMS (Section 6) already
covers much of this ground, and a device overlay built on the same core would
let a spinout carry its parent lab's quality system with it rather than
starting again from scratch.

## 5. Implementation: QMS as Code

Git is a version-control system widely used in the software industry.  In
Stack Overflow's 2022 developer survey, 97% of professional developers
reported using it [@stackoverflow2022survey].  Git tracks a collection of
files, called a *repository*, and records every change made to them,
including what changed, who changed it, when, and a message explaining why.
Each recorded change is called a *commit*, and the sequence of commits forms
the repository's history.  The history is designed to be tamper-evident, since
changing an earlier commit changes the identity of every commit after it.  A
*tag* marks a particular point in the history, such as an approved release.

Git is usually used through a hosting platform, or *forge*, such as GitHub,
GitLab, Gitea or Forgejo.  A forge hosts many repositories, each of which can
be public or restricted to named people.  Forges add two key features.  A
*pull request* (a *merge request* on GitLab) proposes a change, shows exactly
what would change, and records the review, discussion and approval before the
change is accepted.  An *issue* is a tracked item, such as a problem report or
a task, with its own discussion and history.  Forges can also run automated
checks on every proposed change, known as *continuous integration* (CI).
Researchers already use these tools for code.  This proposal uses them for the
documents and records of a quality system.

### 5.1 Minimal Primitives

The core requirements of a QMS are generic.  ISO 9001 requires controlled
documents to be reviewed and approved, protected from loss of integrity, and
subject to "control of changes (e.g. version control)" [@iso9001].  ISO 13485
adds that documents be approved "prior to issue", that "the current revision
status of and changes to documents are identified", and that the "unintended
use of obsolete documents" be prevented [@iso13485].  For clinical research,
ICH E6(R2) expects essential documents to be stored in a system that provides
"document identification, version history, search, and retrieval", and data
changes to be documented with "no deletion of entered data"
[@fda2018e6r2].  Each of these maps onto a feature that every forge already
provides.

| QMS requirement                     | Git or forge primitive                 |
|-------------------------------------|----------------------------------------|
| Version history; identify changes   | Commits                                |
| Current approved version            | Head of a protected main branch        |
| Review and approval before issue    | Pull requests with required approval   |
| Identify released versions          | Tags (optional)                        |
| Nonconformities, CAPA, findings     | Issues with labels                     |
| Standardized forms and records      | Issue, pull request and file templates |
| Access control and confidentiality  | Repository permissions (Section 5.2)   |
| Automated conformance checks        | CI (optional)                          |

Table: QMS requirements and the corresponding git or forge primitives to
implement them.

Because nothing reaches the protected main branch without an approved pull
request, its head is, by definition, the current approved version of every
document.  Each document also carries its own effective date, so a revision
can be approved before it takes effect, for example while staff are
retrained.  Earlier versions remain in the history for reference but not at
the point of use, and staff are trained that the main branch is the only
authoritative source.  Any copy printed or downloaded from it is marked as
uncontrolled.

None of these primitives are exotic.  Each is available on every major forge,
which is what makes the vendor neutrality described in Section 5.3 possible.
Not every requirement maps this cleanly, however.  Electronic signatures that
meet 21 CFR Part 11 need additional work (Section 8.1), and some records, such
as training, may belong in institutional systems rather than a repository
(Section 8.3).

### 5.2 Repository Structure

A QMS built on git is not a single repository but several, each with its own
history and access controls.  How documents and records are divided among
them determines what is shared, what is kept private, and who can see what.
The structure below is a default, which domain overlays and individual sites
can adapt.

- **Controlled documents.**  The Quality Manual, SOPs and templates live in
  one repository.  This is the public, shared repository described in
  Section 4.2, and the one other institutions adopt.
- **Studies and projects.**  Each study or project has its own repository for
  its plans, records, deviations and nonconformities. Access is restricted to
  the people working on it.
- **Personnel records.**  Records that belong to individuals, such as
  training, need even tighter access.  Options include one repository per
  staff member, a single restricted repository, or the institution's existing
  HR or learning-management system (Section 8.3).

Repositories should also be divided by who routinely inspects them, not only
by who may read them.  Some quality records are shown to regulators and
sponsors as a matter of course, while others are kept internal to protect
candor.  For clinical research, ICH E6(R2) states that "to preserve the
independence and value of the audit function, the regulatory authority(ies)
should not routinely request the audit reports" [@fda2018e6r2].  The line is
not the same everywhere, however.  For medical devices, FDA's Quality
Management System Regulation, effective since February 2026, "gives the FDA
the authority to inspect management review, quality audits, and supplier audit
reports" [@fda2026qmsrfaq].  Keeping these records in separate repositories
lets each domain draw the line where its own regulations require.

### 5.3 Deliberate Vendor Neutrality

The idea of running a QMS on a forge is not new.  GitLab publishes guidance on
"Meeting ISO 13485:2016 Requirements with GitLab", mapping features such as
merge request approvals, protected branches and issue templates onto a
medical device QMS [@gitlab13485].  It is careful to add, however, that GitLab
"isn't a compliance tool and makes no guarantees about compliance"
[@gitlab13485].  The platform is supplied, but the procedures that make it a
quality system are left to each organization.  That is the gap this project
fills.

The QMS deliberately uses only features common to all of the major forges,
namely GitHub, GitLab, Gitea and Forgejo.  Every primitive in Table 1 meets
that test, and no feature unique to one platform is required.  Gitea, Forgejo
and the community edition of GitLab are open source and can be self-hosted,
so an institution whose data policies require it can keep its quality records
on its own servers.

Neutrality also protects the records themselves.  Documents and their full
history live in git, and every copy of a repository is a complete one, so
moving to another forge means copying the repository.  Issues and pull request
discussions are stored by the forge rather than in git, but the major forges
can import them from one another.  A commercial eQMS, by contrast, keeps
records in a proprietary database, and leaving the vendor can mean negotiating
an export of the very history an auditor may ask to see.

### 5.4 Cost

Because the QMS needs only features common to every forge (Section 5.3), an
institution can choose the hosting arrangement that suits its budget.

- **Self-hosted.**  Gitea and Forgejo are free, open-source forges that
  provide every primitive in Table 1, including protected branches and
  required approvals [@giteabranches; @forgejobranches].  The cost is a
  modest server and the staff time to administer it.
- **Hosted.**  On hosted forges, the features that turn a forge into a QMS
  are in paid tiers.  On GitHub, protected branches on private repositories
  and required reviewers need the Team plan, listed at $4 per user per month
  [@githubpricing; @githubbranches].  On GitLab, approvals on the free tier
  are "optional and don't prevent merging without approval", and required
  approvals need Premium, at $29 per user per month [@gitlabapprovals;
  @gitlabpricing].  For a team of 20, that is roughly $1,000 or $7,000 a year
  respectively, compared with the tens of thousands of dollars a year typical
  of a commercial eQMS (Section 2.4).
- **Academic programs.**  Both vendors offer free plans to academics, with
  conditions.  GitHub offers free GitHub Team to "verified academic faculty
  … for teaching or academic research" [@githubdiscounts; @githubeducation].
  GitLab for Education offers free licenses to accredited, not-for-profit
  institutions whose "primary purpose" is teaching, for "non-commercial
  academic research", but not for "IT operations or campus administration"
  or "commercial research or revenue generation" [@gitlabeducation].  An
  institution-wide QMS, or a study sponsored by industry, falls outside
  GitLab's terms and is not clearly covered by GitHub's, so these offers suit
  pilots and grant-funded research better than an institution's production
  QMS.

The larger saving is not in license fees.  As Section 4.1 argued, the real
cost of a QMS lies in writing and maintaining its content, and an open-source
QMS shares that cost across every institution that adopts it.  Removing both
the license fee and the work of building a QMS from scratch addresses the two
main barriers to adoption in academia.

## 6. Prior Work

Several existing efforts partially address parts of the problem described in
Section 2.

### 6.1 Academic Quality Frameworks

The University of Kentucky's Good Research Practice Resource Center, discussed
in Section 4.1, brings GLP-inspired quality management to academic research
through consultation and training [@littrell2020costs].  The closest effort in
mission is the EQIPD Quality System, developed by a consortium funded by the
European Union's Innovative Medicines Initiative.  It defines research quality
as "the extent to which research data are fit for their intended use", sets
out 18 core requirements, and is "free for anyone to use"
[@bespalov2021eqipd].  EQIPD deliberately "does not prescribe any
pre-determined solutions", offering examples through an online toolbox, and it
is designed for non-regulated preclinical research [@bespalov2021eqipd].  It
says what a research quality system must achieve, but leaves each unit to
build its own, and it offers no route to regulatory-grade evidence.  The QMS
proposed here could serve as one implementation of EQIPD's requirements, with
a path to regulated use where it is needed.

### 6.2 Git-Based Quality Systems

The closest efforts in form come from medical device software.
OpenRegulatory publishes markdown templates on GitHub for ISO 13485, IEC
62304, ISO 14971 and IEC 62366, aimed at device companies
[@openregulatorytemplates].  They are licensed CC BY-NC-SA 4.0, however,
which prohibits commercial use and so excludes the spinouts described in
Section 4.6.  The Royal College of Paediatrics and Child Health (RCPCH) runs
the ISO 13485 QMS for its Digital Growth Charts on GitHub.  Changes are
proposed by pull request and need "at least one approving review" before
merging to a protected branch, and records such as CAPAs, audits and
management reviews are kept as issues created from templates [@rcpchqms].  It
is strong evidence that a git-native QMS works in a regulated setting, but it
serves a single product, although RCPCH intends to extract "generalisable
patterns" into "a shared template" [@rcpchqms].  The most complete effort we
have found is DearAuditor's Open eQMS, released in 2026, "a GitHub-native
electronic Quality Management System baseline" for medical device and
regulated software teams [@dearauditorqms].  It covers ISO 9001, ISO 13485 and
related standards, with an optional overlay for 21 CFR Part 11, and uses
GitHub issues, pull requests, workflows and releases as the quality system of
record.  It also includes a signing ceremony intended for Part 11 contexts,
run by a service outside GitHub that combines a GitHub login with a PIN
[@dearauditorpart11], although the project states that a Part 11 mapping is
"not asserted by the baseline" [@dearauditorqms].  Its SOPs are licensed
CC BY-SA 4.0, which permits commercial use but requires derivatives to adopt
the same license.  It is built specifically on GitHub, however, and aimed at
companies rather than academic research.  On the research side, Chen et al.
describe a wet lab that runs its experiments through GitHub issues and
version control [@chen2025github], showing that researchers will adopt these
tools.  Their focus is reproducibility within the lab, not quality management
or regulation.

| Effort                                    | Open           | Git-native | SOPs      | Academic | Regulatory |
|-------------------------|------------|------------|----------|----------|------------|
| Kentucky GRP Center [@littrell2020costs]  | No             | No         | Partial   | Yes      | Yes        |
| EQIPD [@bespalov2021eqipd]                | Yes            | No         | Partial   | Yes      | No         |
| OpenRegulatory [@openregulatorytemplates] | Non-commercial | Partial    | Yes       | No       | Yes        |
| RCPCH [@rcpchqms]                         | Public         | Yes        | 1 product | No       | Yes        |
| DearAuditor [@dearauditorqms]             | Share-alike    | Yes        | Yes       | No       | Yes        |
| Chen et al. [@chen2025github]             | Yes            | Yes        | No        | Yes      | No         |
| This proposal                             | Yes (CC0)      | Yes        | Yes       | Yes      | Yes        |

Table: Existing efforts compared with this proposal.

This proposal differs from DearAuditor in four ways: its focus on academic
research, including observational studies; its deliberate neutrality across
forges (Section 5.3); its CC0 license; and a design for electronic signatures
that keeps them in git (Section 8.1).

### 6.3 Our Work

This proposal builds on work already done.  At CorticoMetrics, the author (PW)
built the company's QMS on GitLab, and it supported the FDA 510(k) clearance
of the THINQ software in 2020 [@fdak192051].  A git-based QMS has therefore
already carried a product through an FDA submission.  The boilerplate SOPs on
which that QMS was built, since published as `qm-sops` [@qmssops], became the
starting point for `obs-qms` [@obsqms], a QMS for academic institutions
conducting observational studies whose data are intended for regulatory
submissions.  It comprises a Quality Manual and 16 SOPs, released under CC0,
and maps to ISO 9001, ICH E6(R2), E8(R1), E9(R1) and Q9(R1), GAMP 5 and
21 CFR Parts 11 and 54.  `obs-qms` is a template rather than an operating
QMS.  An institution adopts it by copying the repository, running the workflow
described in Section 5 on its own copy, and editing the SOPs to fit its own
structure as it goes.

## 7. Scope of Compliance Claims

No quality system makes an institution compliant by itself.  Compliance
depends on how a system is implemented, followed and audited at each site, so
the claims made for this QMS are deliberately limited to what its design can
support.  They fall into three tiers.

| Tier | Target                                         | What is needed                     |
|------|------------------------------------------------|------------------------------------|
| 1    | Reproducibility, provenance and change control | Git and forge primitives alone     |
| 2    | Domain-specific quality processes              | Primitives plus SOPs and templates |
| 3    | Electronic signatures under 21 CFR Part 11     | Additional work (Section 8.1)      |

Table: Tiers of compliance claims.

**Tier 1** is met by the primitives of Section 5.1 alone.  Any research group
that uses git and a forge as described gains a versioned, attributable history
of its procedures and records, and a reviewed record of every change, whether
or not it adopts the rest of the QMS.

**Tier 2** needs the SOPs and templates as well.  The primitives supply the
document and record control that ISO 9001, ISO 13485 and ICH E6 require
(Section 5.1), but each domain also needs its own quality processes, such as
study design review, monitoring and adverse-event handling for observational
studies, or design control and risk management for medical device software.
The SOPs define those processes, including who reviews and approves, which
records are kept, and for how long.  This is the tier `obs-qms` targets for
observational studies (Section 6.3).

**Tier 3** is not yet implemented.  21 CFR Part 11 requires each signed
electronic record to show "the printed name of the signer", "the date and time
when the signature was executed" and "the meaning (such as review, approval,
responsibility, or authorship)" of the signature.  Signatures must be "linked
to their respective electronic records" so that they "cannot be excised,
copied, or otherwise transferred", and those not based on biometrics must
"employ at least two distinct identification components such as an
identification code and password" [@cfr11].  Part 11 also requires
"validation of systems" (Section 8.2).  A pull request approval records who
approved a change and when, but does not by itself meet all of these
requirements.  Until the work described in Section 8.1 is done, records that
need a Part 11 signature should be signed in a system that provides one.

## 8. Objections and Limitations

### 8.1 Electronic Signatures

Todo. Working on this now.  https://github.com/AliakseiT/dearauditor-qms-baseline looks promising

### 8.2 Platform Validation

Todo. We should provide installation and validation guidance

### 8.3 Training Records and Non-Document Controls

### 8.4 Cultural Adoption

## 9. Roadmap

