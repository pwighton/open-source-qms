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

## 4. Why *Open Source*

An open-source QMS removes the licensing cost, but being open source does more
than that.  It changes how the QMS is built, maintained, and trusted.

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

Sharing what has already been built changes this.  The University of
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
[@freedman2015economics].  An open-source QMS gives the field a place to do
that work, and to converge over time on controls the community as a whole has
reviewed.

### 4.3 Rationale Is Preserved, Not Just the Requirement

### 4.4 Network Effects

### 4.5 A Teaching Artifact

### 4.6 Extensibility Across Domains

## 5. Prior Work

## 6. Implementation: QMS as Code

### 6.1 Minimal Primitives

### 6.2 Deliberate Vendor Neutrality

### 6.3 Cost
