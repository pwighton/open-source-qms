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

### 5.3 Deliberate Vendor Neutrality

### 5.4 Cost

## 6. Prior Work
