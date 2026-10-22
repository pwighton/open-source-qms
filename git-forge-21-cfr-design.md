# Electronic Signatures on Git and a Forge: Design Notes for 21 CFR Part 11

*Working design document.  Started 2026-10-22.  This is the full-detail
companion to Section 8.1 of `open-source-qms.md`; the pitch will summarise
it.  Items marked **(verify)** have not yet been checked against a primary
source.*

## 1. Purpose and Scope

The open-source QMS (see `open-source-qms.md`) uses git and a forge (GitHub,
GitLab, Gitea or Forgejo) as its document and record control system.  Its
Tier 1 and Tier 2 claims (Section 7 of the pitch) do not need electronic
signatures.  Tier 3 does: records that must carry a signature meeting 21 CFR
Part 11 currently need a separate system.

This document works out, requirement by requirement, what git plus a forge
already provides, where it falls short of Part 11, and the smallest addition
that would close each gap.  The aim is a design that:

- adds as little new machinery as possible;
- keeps signatures in git, so they survive a change of forge (Section 5.3 of
  the pitch);
- works the same way on every major forge;
- can be validated (Section 8.2 of the pitch).

### 1.1 Status Summary (2026-10-22)

| Row | Requirement | Status | Details |
|---|---|---|---|
| 1 | Identity (11.100, 11.200, 11.300) | Solved: forge accounts or keys mapped to people in a controlled signer registry; several authentication options (Section 6.5) | Sections 5.1, 6.5, 7.2 |
| 2 | Signature/record linking (11.70) | Solved for documents stored as files (signed tags on document blobs). **Open for records stored as forge issues** | Sections 5.2, 6.2 |
| 3 | Meaning (11.50(a)(3)) | Solved: Approvals-table roles as meanings, inside the signed tag | Sections 5.3, 5.3.1 |
| 4 | Date and time (11.50(a)(2), 11.10(e)) | Solvable: RFC 3161 trusted timestamps.  Choices open | Section 5.4 |
| 5 | Authentication at signing (11.200, 11.300) | Solved, with several options: device keys (hardware token, built-in TPM/Secure Enclave, phone passkey), a re-authenticating server (commercial, self-hosted, or added to an open-source forge), or handwritten signatures on rendered copies.  Strongest: FIDO2 token with PIN and touch, provable from the signature | Sections 5.5, 6.5 |
| 6 | Human-readable form (11.50(b)) | Solved: signature blocks filled at render time from verified signatures | Section 5.6 |

**The design in two sentences:** the *evidence format* is fixed: each
signature is a signed git tag on the exact content of one document,
timestamped by an RFC 3161 authority, verified by CI against a controlled
signer registry, and shown in the document's Approvals table only in rendered
copies (rows 2, 3, 4 and 6).  *How the signer authenticates* (rows 1 and 5)
is a choice among several options (Section 6.5); the strongest and
server-free option is a FIDO2 hardware token requiring PIN and touch.

**Open decisions:**

- records stored as forge issues: keep signed records as files, sign a
  snapshot, or exclude them from Part 11 signatures (Section 5.2);
- effective date: set before signing, or kept out of the file and filled at
  render time (Section 5.3.1);
- which timestamping authority, and where tokens are stored (Section 5.4);
- which authentication option(s) to support (Section 6.5); if tokens, FIDO2
  vs OpenPGP (FIDO2 recommended; Section 5.5);
- where rendered copies are published, and whether CI signs PDFs
  (Section 5.6).

Items still to verify are collected in Section 9.

## 2. Background and Terminology

### 2.1 Git objects and hashes

Git stores everything as *objects*, each identified by a hash of its content:

- a **blob** is the content of one file at one moment;
- a **tree** is a directory listing (names and the blobs or trees they point
  to);
- a **commit** points to a tree (a snapshot of the whole repository), to its
  parent commit(s), and records an author, a committer, two dates and a
  message;
- an **annotated tag** is an object that points to any other object (usually
  a commit, but it can be a blob) and carries its own name, tagger, date and
  message.

Because each object's identity is the hash of its content, and commits
include their parents' hashes, changing anything in history changes every
hash after it.  This makes git history *tamper-evident*: changes can be made,
but not without being detectable.

Git's default hash is SHA-1 in a hardened form that detects known collision
attacks.  Git also supports SHA-256 repositories, but forge support is
limited **(verify current GitHub/GitLab/Gitea support)**.

### 2.2 The forge

A forge hosts repositories and adds features that are *not* part of git:
user accounts and authentication, pull requests (merge requests on GitLab),
reviews and approvals, issues, protected branches and tags, and CI.  These
live in the forge's own database.  This distinction matters throughout: data
in git travels with every clone; data in the forge's database does not.

### 2.3 Digital signatures

A digital signature uses a **key pair**: a *private key* that only the signer
can use, and a *public key* that anyone can use to check signatures.  Signing
some data computes a value from the data and the private key.  Anyone with
the public key can confirm two things: that the signature was made by the
holder of the private key, and that the data has not changed by a single
byte since.

Git supports signing commits (`git commit -S`) and tags (`git tag -s`) with
three kinds of key: OpenPGP (GPG), SSH, and X.509 certificates.  It verifies
them with `git verify-commit` and `git verify-tag`.  GitHub, GitLab and
Gitea can show a "Verified" badge when the public key is registered with the
user's account.

## 3. The Part 11 Requirements

Quoted from the current eCFR text of 21 CFR Part 11 (checked 2026-10-22):

- **11.10(a)** "Validation of systems to ensure accuracy, reliability,
  consistent intended performance, and the ability to discern invalid or
  altered records."
- **11.10(e)** "Use of secure, computer-generated, time-stamped audit trails
  to independently record the date and time of operator entries and actions
  that create, modify, or delete electronic records.  Record changes shall not
  obscure previously recorded information."
- **11.50(a)** Signed electronic records "shall contain information
  associated with the signing that clearly indicates all of the following:
  (1) The printed name of the signer; (2) The date and time when the signature
  was executed; and (3) The meaning (such as review, approval, responsibility,
  or authorship) associated with the signature."
- **11.50(b)** These items "shall be included as part of any human readable
  form of the electronic record (such as electronic display or printout)."
- **11.70** "Electronic signatures and handwritten signatures executed to
  electronic records shall be linked to their respective electronic records to
  ensure that the signatures cannot be excised, copied, or otherwise
  transferred to falsify an electronic record by ordinary means."
- **11.100(a)** "Each electronic signature shall be unique to one individual
  and shall not be reused by, or reassigned to, anyone else."
- **11.100(b)** The organization "shall verify the identity of the
  individual" before sanctioning their electronic signature.
- **11.100(c)** Users must certify to FDA that their electronic signatures
  "are intended to be the legally binding equivalent of traditional
  handwritten signatures."
- **11.200(a)(1)** Non-biometric signatures must "Employ at least two distinct
  identification components such as an identification code and password."
  - (i) In "a single, continuous period of controlled system access, the first
    signing shall be executed using all electronic signature components;
    subsequent signings shall be executed using at least one electronic
    signature component that is only executable by, and designed to be used
    only by, the individual."
  - (ii) Signings "not performed during a single, continuous period of
    controlled system access" must each use "all of the electronic signature
    components."
- **11.200(a)(2)** Signatures must "Be used only by their genuine owners."
- **11.200(a)(3)** They must be administered so that use by anyone other than
  the genuine owner "requires collaboration of two or more individuals."
- **11.300** Controls for identification codes and passwords "to ensure
  their security and integrity", including:
  - (a) "Maintaining the uniqueness of each combined identification code and
    password";
  - (b) "Ensuring that identification code and password issuances are
    periodically checked, recalled, or revised (e.g., to cover such events as
    password aging)";
  - (c) "loss management procedures to electronically deauthorize lost,
    stolen, missing, or otherwise potentially compromised tokens, cards, and
    other devices", and to issue replacements "using suitable, rigorous
    controls";
  - (d) "transaction safeguards to prevent unauthorized use", and to "detect
    and report in an immediate and urgent manner any attempts at their
    unauthorized use";
  - (e) "Initial and periodic testing of devices, such as tokens or cards,
    that bear or generate identification code or password information".

**FDA enforcement policy (verify).**  From memory, FDA's 2003 guidance *Part
11, Electronic Records; Electronic Signatures — Scope and Application* applies
enforcement discretion to some 11.10 controls (such as validation and audit
trails) but not to the signature requirements of 11.50, 11.70, 11.100, 11.200
and 11.300.  If so, signatures are the part of Part 11 that must be met in
full.  Download and quote before relying on this.

## 4. The Baseline: Git Plus a Forge

The comparison throughout is against **git plus a forge**, not plain git.
When Alice approves a pull request, she does so in a forge session she logged
into with her username and password (and often MFA or institutional single
sign-on).  The forge records the approval in its database as a *review
record*, roughly:

```
pull request: 42
reviewer:     alice
state:        APPROVED
commit:       abc123
submitted at: 2026-10-22 15:04 UTC
```

The content she approved (commit `abc123` and its files) is in git.  The
fact that she approved it is not: it is a row in the forge's database.  (On
GitHub, for example, it is exposed through the API as a "pull request review"
with a `commit_id` field.)

## 5. Requirement-by-Requirement Analysis

### 5.1 Row 1: Identity (11.100(a)(b), 11.200, 11.300)

**What git plus a forge provides.**  Each approval is recorded against a
forge account.  Accounts are unique and authenticated, so if accounts are
never shared, approvals are "unique to one individual" (11.100(a)).  The
organization verifies the person's identity when the account is created
(11.100(b)); this is procedural, and institutional single sign-on largely
handles it because the university has already verified its staff.  Password
rules come from the forge or the single-sign-on system (11.300).  The
free-text author name in a commit stops mattering, because the approval
record, not the commit author, is what counts.

**Gap 1: authentication happens at login, not at signing.**  This is the main
gap.  Forge sessions last days or weeks, so approving is a single click
inside an existing session.  11.200(a)(1) requires all signature components
at the first signing in a session and at every signing outside a continuous
session.  As far as is known, no major forge re-prompts for a password when
someone approves a pull request.  GitHub's "sudo mode" re-prompts only for
certain administrative actions **(verify)**.

**Gap 2: the "printed name" is not controlled.**  11.50(a)(1) requires the
signer's printed name.  The forge records a username; the display name is
profile text the user can change.  Something under document control must map
each account (or signing key) to a legal name.

**Gap 3: administrators can act as other users.**  On self-hosted GitLab, and
reportedly GitHub Enterprise Server **(verify)**, an administrator can
impersonate a user; any administrator with database access can also edit
records directly.  That lets one person misuse another's signature, contrary
to 11.200(a)(3).  Procedural controls (audit logging, two-person
administration) mitigate this but do not remove it.

**Conclusion for row 1.**  The forge establishes *who* the approver is.  It
does not prove that the person was present and authenticated *at the moment
of approval*, and it leaves the printed name and administrator
impersonation unresolved.

### 5.2 Row 2: Signature/Record Linking (11.70)

**What git plus a forge provides.**  The review record names the commit the
reviewer approved, so the forge knows which version was approved.  Forges can
also discard approvals when new commits are pushed (GitHub: "dismiss stale
pull request approvals"; GitLab and Gitea have equivalents).

**Gap 1: approvals can be transferred by an ordinary action.**  If stale
approvals are not discarded, Paul can push new content after Alice approves
and merge anyway; her approval then stands for text she never saw.  On GitHub
this setting is believed to be opt-in **(verify each forge's default)**.  It
can be fixed by configuration, but the QMS would have to require it and
verify that it stays on.

**Gap 2: the approval record is in the forge's database, not in git.**  The
record that ties Alice's approval to commit `abc123` (Section 4) is a
database row.  An administrator can edit it without trace; nobody outside the
forge can check it independently; it is only as trustworthy as the forge.

**Gap 3: approval records do not survive leaving the forge.**  Because they
are not in git, they may be lost when migrating between forges.

**Gap 4: after merging, the approved commit may not be on `main`.**  With
"squash" or "rebase" merges the forge creates new commits, so commit `abc123`
never appears on `main`.  The content is usually identical, but proving that
takes reconstruction.

**Gap 5: a pull request approval covers the whole change.**  If a pull request
changes three SOPs, one approval covers all three, with no record of which
document revision was signed.

**Conclusion for row 2.**  The forge's link between approval and content is
real but configurable, editable and forge-bound.

**Status of row 2 (2026-10-22): solved by design for documents stored as
files; open for records stored as issues.**

*How it is solved.*  Each signature is a signed tag on the document's blob
(Section 6.2).  The tag names the content by its hash, and the signature
covers that name, so the link is part of the signed data rather than a
separate record.  Against each part of 11.70:

- *Linked:* the content hash is inside the signed tag object.
- *Copied or otherwise transferred:* re-pointing Alice's tag at other content
  changes the signed data, so verification fails; making a new tag needs her
  private key (on her token, behind her PIN); reusing her tag unchanged fails
  because CI compares its hash with the actual file; presenting it as
  covering another file with identical content fails because CI checks the
  signed document name and path.  None of these is possible "by ordinary
  means".  (Contrast the forge approval, which an ordinary push could
  effectively transfer if stale approvals were not discarded.)
- *Excised:* deleting a tag erases evidence but does not falsify the
  document.  Protected tags prevent deletion by ordinary users; CI on `main`
  fails any approved revision lacking its required signatures, so deletion is
  detected; mirrors and backups keep copies.
- *Independent of the forge:* no reliance on stale-approval settings; immune
  to squash or rebase merges (the document content on `main` is unchanged);
  survives migration.

*Dependencies* (conditions the solution relies on, not reasons to reopen it):

1. **Hash strength.**  Everything rests on the blob hash being infeasible to
   forge.  Git's hardened SHA-1 detects known collision attacks; SHA-256
   repositories would remove the concern but have limited forge support
   (verify).  State as a limitation.
2. **Protected tags are a forge feature.**  Prevention of deletion relies on
   the forge; detection (CI, mirrors) does not.  Excision is "prevented by the
   forge, detected independently".
3. **Trusted time (row 4).**  If a key is later revoked (e.g. lost token),
   deciding whether a signature was made before revocation needs a trusted
   time; the tag's own date is the signer's clock.  Long-term validity of
   signatures therefore depends on row 4.
4. **Validation of the verifier.**  CI enforces all of the above, so it must
   be validated (pitch Section 8.2).

*Not covered: records stored as forge issues.*  The design signs files.  The
pitch (Section 5.1) puts nonconformities, CAPAs and audit findings in forge
issues, whose text, comments and status live in the forge's database, not in
git.  If such a record needs a Part 11 signature (e.g. approving a CAPA's
closure), signed blobs do not reach it.  Options:

- (a) records that need signatures are kept as files (e.g. `CAPA-012.md`),
  with the issue used only to track the work; they are signed like SOPs
  (most consistent with this design);
- (b) CI renders the issue to a file at the moment of approval, and that
  snapshot is signed (needs an issue-to-file export step);
- (c) issue-based records do not carry Part 11 signatures, stated in the
  pitch's Section 7 tiers.

Decision open.

### 5.3 Row 3: Meaning of the Signature (11.50(a)(3))

**The requirement.**  A signed record must clearly indicate "the meaning
(such as review, approval, responsibility, or authorship) associated with the
signature" (11.50(a)(3)), and that meaning must be "subject to the same
controls as for electronic records" and appear in any human-readable form
(11.50(b)).  Meaning matters because the same person's signature can attest
to quite different things: "I wrote this", "I checked this", "I approve this
for use", "I take responsibility for this".

**What git plus a forge provides.**

- A commit implies, at most, authorship of the change.  It says nothing about
  review or approval.
- A pull request review has a state: on GitHub, "Approved", "Changes
  requested" or "Commented"; GitLab and Gitea are similar.  "Approved" is a
  meaning, but only one: it cannot distinguish a peer review from a QA
  approval, or record that someone is signing as the document's author.
- GitLab Premium approval rules can be named (e.g. "QA approval"), and
  CODEOWNERS can require particular reviewers, which goes some way towards
  role-specific approvals **(verify whether the rule name is stored with each
  approval)**.

**Gaps.**

1. **Too few meanings.**  One "Approved" state cannot express the distinct
   meanings a QMS needs (authorship, technical review, QA approval).
2. **The meaning is not under record controls.**  The review state is a field
   in the forge's database, with the same problems as row 2: editable by an
   administrator, not verifiable outside the forge, not portable.
3. **No controlled definition.**  Nothing defines what "Approved" commits the
   signer to.  A meaning is only useful if signers and readers understand it
   the same way.

**How the design addresses it.**

1. **The meaning is a field in the signed message** (`Meaning: Approval`;
   Section 6.2).  The signature covers it, so it cannot be changed without
   breaking verification (gap 2), and it travels with the tag.
2. **A controlled vocabulary of meanings, taken from the Approvals table.**
   Every obs-qms document (QM-001 and SOP-001 to SOP-016, checked
   2026-10-22) has the same table in its header:

   ```
   **Approvals**

   | Role | Name | Signature / Date |
   |------|------|------------------|
   | Author |  |  |
   | Approver |  |  |
   | QA Representative |  |  |
   ```

   Its three roles are the vocabulary.  The electronic-signature SOP defines
   each as a signature meaning (draft wording):

   | Role in table | Signature meaning | Definition |
   |---|---|---|
   | Author | Authorship | "I wrote or revised this document and it is complete and accurate to the best of my knowledge." |
   | Approver | Approval | "I approve this document for use." |
   | QA Representative | QA Approval | "This document meets the requirements of the QMS." |

   (Gaps 1 and 3.)
3. **The helper shows the meaning and its definition before signing,** and
   offers only the roles listed in that document's Approvals table, so the
   signer knows exactly what they are attesting to at the moment they sign.
4. **The Approvals table is the required-signatures rule.**  Rather than a
   separate configuration file, CI reads each document's Approvals table and
   requires one valid signature for each role listed, signed by a person the
   signer registry authorises for that role.  A document or record type that
   needs different signatures simply has a different table.  The rule lives
   in the document, under the same change control as its content: one source
   of truth.  In the Paul/Alice/Bob example, Paul signs *Authorship* and Alice
   and Bob sign *Approval* and *QA Approval*.
5. **Separation of duties** (a QMS norm, not a Part 11 requirement): CI can
   refuse an *Approval* or *QA Approval* by the same person who signed
   *Authorship* of that revision.
6. **The meaning appears in rendered copies** (row 6), in the Approvals
   table, filled at render time (Section 5.3.1).

**Status of row 3: solved by design.**  The meaning is part of the signed
data, defined by the Approvals table's roles, shown to the signer, enforced by
CI per document, and rendered in output.  Remaining work is procedural:
writing the role definitions into the electronic-signature SOP.

#### 5.3.1 The Approvals and Document Control tables must stay blank in source

**The Approvals table.**  Names and dates must never be typed into the
Approvals table in the markdown source, for two reasons:

1. *Typed text is not a signature.*  Anyone with commit access could type
   "Alice Smith / 2026-10-22"; it is a claim, not proof (as with the metadata
   file, Section 6.1).
2. *Filling it in breaks the signatures it records.*  A signature covers the
   document's exact content (its blob hash).  Writing Alice's name into the
   table after she signs changes the content and therefore the hash, so the
   content on `main` no longer matches what Alice (or Bob) signed, and every
   signature fails verification.  A document cannot contain its own
   signatures, because adding them changes the document.

**Resolution: fill the table at render time only.**  The source table stays
blank, listing only the roles required.  When CI renders a PDF or docx, it
finds the verified signature tags for that exact document version and fills
each row with the signer's printed name (from the signer registry), the
trusted date and time (row 4), and the meaning, plus a note such as
"Electronically signed; verify: tag `sig/SOP-002/…`".  The rendered copy shows
the signatures (11.50(b)); the source is unchanged, so signatures keep
verifying; every value comes from a verified signature, not typed text.  CI
can also check that source Approvals tables stay blank.

**The Document Control table.**  Each document also has:

```
| Document ID | Revision | Effective date |
|-------------|----------|----------------|
| SOP-002 | _(assigned on release)_ | _(assigned on release)_ |
```

"Assigned on release" means filled after approval, which hits the same
problem.

- *Revision* is fine: it can be set in the pull request before anyone signs,
  so the signed content already says "Rev 4".  CI checks that the signature's
  `Document: … Rev 4` matches the header.
- *Effective date* is the problem.  The pitch (Section 5.1) merges on approval
  and relies on each document's effective date so that a revision can be
  approved before it takes effect (e.g. while staff are retrained).  Writing
  the date into the file after approval would change the content and break
  the signatures.  Options:
  - **(a) Set it before signing.**  The author puts the planned effective date
    in the pull request and approvers approve it as content.  Simple; but if
    the date slips, changing it is a new revision needing re-signing.
  - **(b) Keep it out of the file.**  Record it as a field in the QA Approval
    signature (e.g. `Effective-Date: 2026-11-15`) or in a small release
    record, and have the render step fill the Document Control table, as for
    the Approvals table.  More flexible and consistent with how signatures
    are handled.

  Decision open.  It affects obs-qms (SOP-002 in particular) and the pitch's
  Section 5.1 sentence "Each document also carries its own effective date".

**Records.**  The same approach works for records stored as files (row 2,
option (a)): a CAPA record file carries its own Approvals table listing the
roles it needs.

### 5.4 Row 4: Date and Time (11.50(a)(2), 11.10(e))

**The requirements.**  A signed record must show "the date and time when the
signature was executed" (11.50(a)(2)).  More broadly, audit trails must be
"secure, computer-generated, time-stamped" and must "independently record the
date and time of operator entries and actions that create, modify, or delete
electronic records" (11.10(e)).  The key words are *secure* and
*independently*: the time must not be something the signer, or anyone else
with an interest in the record, can choose.

Trusted time also matters for row 2 (dependency 3).  If Alice's key is
revoked (for example, her token is lost on 1 December), signatures she made
before that date should remain valid and any made after it should not.
Telling the two apart requires knowing, from an independent source, when each
signature was made.

**What git plus a forge provides.**

- *Git's own dates come from the user's computer.*  Every commit records an
  author date and a committer date; every annotated tag records a tagger date.
  All are taken from the clock of the machine that created the object, and
  can be set to anything (`git commit --date`, the `GIT_COMMITTER_DATE`
  environment variable, or simply a wrong system clock).  Once an object is
  signed, its date cannot be changed without breaking the signature, but the
  signer chose it in the first place.  So a git date is a claim by the signer,
  not an independent record.
- *The forge's dates come from its server.*  When Alice submits a pull request
  review, the forge records `submitted_at` from its own clock; pushes and
  merges are logged with server times too.  These are computer-generated and
  independent of the user.  But, as in row 2, they live in the forge's
  database: editable by an administrator, not verifiable outside the forge,
  and not carried by the repository.  Some are also short-lived: GitHub's
  public events API, for example, keeps only recent events **(verify
  retention)**; full audit logs are an enterprise feature on some forges.

**Gaps.**

1. The time inside a signed tag is the signer's own clock: not independent.
2. The forge's server times are independent, but forge-bound and editable,
   and do not attach to the signature itself.
3. Without trusted time, a revoked key cannot be handled correctly (row 2,
   dependency 3).

**Approaches considered.**

1. **Forge receipt time.**  Use the time the forge received the pushed
   signature tag.  Independent, but stored in the forge's database (and not
   always retained), so it has the same weaknesses as forge approvals.
2. **A CI bot records the time.**  When a signature tag is pushed, a CI job
   records the server time and commits it to the repository.  This moves the
   time into git, but its trustworthiness is that of the bot and the CI
   server's clock, and the bot needs validating.
3. **An RFC 3161 trusted timestamp** (recommended; details below).
4. **The Sigstore transparency log** (gitsign).  Each entry carries a signed
   timestamp from the log.  Comes free with gitsign, but ties trusted time to
   the Sigstore infrastructure; Sigstore also runs an RFC 3161 timestamp
   service **(verify)**, which is approach 3 by another route.
5. **OpenTimestamps**, which anchors a hash in the Bitcoin blockchain.  Free and
   decentralised, and git integrations exist, but confirmation takes hours and
   it adds a blockchain dependency that would be hard to justify to a QA
   department or an auditor.  Not recommended **(verify git integration)**.

**Recommended: RFC 3161 trusted timestamps.**  RFC 3161 is an Internet
standard for *timestamping authorities* (TSAs).  It is the same mechanism
used to timestamp signed software, and in Europe qualified TSAs underpin
legally recognised electronic timestamps under eIDAS.  It works like this:

1. The client computes a hash of the thing to be timestamped (here, the
   signed tag object).  Only the hash is sent, so the TSA never sees the
   document.
2. The TSA returns a *timestamp token*: a small data structure, signed with
   the TSA's own key, stating "this hash existed at time T" (from the TSA's
   clock, which is typically synchronised to a reliable time source).
3. Anyone can later verify the token with standard tools (`openssl ts
   -verify`) and the TSA's certificate.

Several TSAs offer free public service (for example FreeTSA, and the
timestamp servers that certificate authorities such as DigiCert and Sectigo
run for code signing) **(verify terms of use)**; an institution could also run
its own or use a commercial one.

**How it fits the design.**

1. Immediately after Alice's token signs the tag, the helper hashes the
   signed tag object and requests a timestamp token from the configured TSA.
2. The token is stored with the signature and pushed with it.  Storage
   options:
   - a *git note* attached to the tag object (`refs/notes/timestamps`):
     simple, travels with clones that fetch notes, but forges do not display
     notes and may not let them be protected **(verify)**;
   - a *second annotated tag* pointing at the signature tag, whose message
     contains the token: protectable like any tag;
   - a *file* committed by CI to a `signatures/` directory.
   Because the token is self-verifying (it carries the TSA's signature over
   the hash), *where* it is stored does not need to be trusted for
   authenticity: nobody can forge or alter a token without the TSA's key.
   Storage only needs to protect it from deletion (as with signature tags in
   row 2: protected tags, mirrors, CI checks).
3. CI verifies each token against the TSA's certificate and checks that it
   covers the signature tag.  It also compares the TSA time with the signer's
   own tagger date and flags large differences (say, more than a few
   minutes), which catch wrong clocks and attempts to backdate.
4. The *TSA time* is the authoritative "date and time when the signature was
   executed".  It is what the render step prints in the Approvals table (row 6)
   and what decides validity against key revocation dates in the signer
   registry.

**What a timestamp proves, precisely.**  A token proves that the signed tag
existed *no later than* time T.  It does not prove the signature was not made
earlier.  Because the helper requests the token within seconds of signing,
and CI checks it against the signer's own date, the gap is small in practice.
For revocation this is the direction that matters: a token dated before the
revocation proves the signature predates it.

**Long-term validity.**  A TSA's certificate eventually expires, and its
algorithms may weaken.  The standard archival practice is to re-timestamp
older tokens periodically with a current TSA, so the chain of evidence stays
verifiable.  This becomes part of record retention (a periodic CI job).

**Beyond signatures: the audit trail (11.10(e)).**  The same mechanism can
give every change to a controlled document an independent time: CI requests a
timestamp for each merge commit on `main` and stores it the same way.  The
git history then becomes an audit trail whose times are independent of the
people making changes.

**Status of row 4: solvable by design; choices open.**  RFC 3161 timestamps
give an independent, verifiable, portable time for each signature (and
optionally each change), and close row 2's revocation dependency.  Open
choices: which TSA (public, commercial or institutional); how tokens are
stored (note, tag or file); whether merges on `main` are also timestamped.

### 5.5 Row 5: Authentication at Signing (11.200, 11.300)

**The requirements.**  Section 3 quotes them in full.  In summary:

- every non-biometric signature uses "at least two distinct identification
  components such as an identification code and password" (11.200(a)(1));
- within "a single, continuous period of controlled system access", the
  *first* signing uses all components and later ones at least one component
  "only executable by, and designed to be used only by, the individual"
  (11.200(a)(1)(i)); signings outside such a period each use all components
  (11.200(a)(1)(ii));
- signatures are used "only by their genuine owners" (11.200(a)(2)), and
  misuse "requires collaboration of two or more individuals" (11.200(a)(3));
- the identification codes, passwords and devices are managed (11.300):
  unique, periodically revised, deauthorised when lost, protected against
  and alerting on unauthorised use, and devices tested.

Note that 11.300 explicitly anticipates hardware: (c) speaks of "tokens,
cards, and other devices", and (e) of "testing of devices, such as tokens or
cards".  Hardware tokens are therefore squarely within what Part 11
contemplates.

**What git plus a forge provides** (Section 5.1, gap 1).  Logging in to the
forge uses a username and password (often with MFA), but logging in is not
signing.  Approving a pull request is a single click inside an existing
session that may be days old.  So the forge fails (i), since the first
signing in a session does not re-use all components, and (ii), since
approvals made long after login do not use any.  Session inactivity timeouts
shorten the session but do not add a prompt at the moment of signing.

**How the design addresses it (hardware token, recommended).**

1. *Every signing uses all components.*  The token is configured to require
   the PIN and a touch for each signature.  So every signing satisfies the
   stricter rule (ii), and therefore (i) as well.  There is no "session" to
   reason about: each signature stands alone.
2. *What the two components are.*  Two readings, both satisfied:
   - Part 11's own example: the *identification code* is the key's identity
     (its public key, mapped to a person in the signer registry), and the
     *password* is the PIN;
   - multi-factor reading: *something you have* (the token, from which the
     key cannot be copied) and *something you know* (the PIN).
   Whether FDA would accept this is a regulatory judgment (Section 9), but the
   design meets the requirement under either reading.
3. *Touch defeats silent misuse.*  Requiring a physical touch (user presence)
   means malware on the signer's computer cannot sign in the background, even
   with the token plugged in.
4. *Genuine owners and two-person misuse (11.200(a)(2), (a)(3)).*  Forging a
   signature requires the token *and* the PIN.  No server holds the key, so
   no administrator can sign as someone else.  Issuance must preserve this:
   - the key is generated *on the token*, in the signer's presence;
   - the signer sets their own PIN (the default is changed at issuance), so
     the person issuing the token never knows it;
   - adding the public key to the signer registry is a pull request that a
     second person must approve.
5. *Device and PIN management (11.300).*
   - (a) uniqueness: one token and key per person, enforced by the registry;
   - (b) periodic review: registry entries reviewed periodically (e.g.
     annually, alongside training records); PIN changes per the
     electronic-signature SOP;
   - (c) loss: a lost token is revoked by adding a `valid-before` date to its
     registry entry (the allowed-signers file supports `valid-after` and
     `valid-before`), and a replacement is issued with the same controls as
     the original;
   - (d) unauthorised use: tokens lock after a small number of wrong PINs
     **(verify counts for FIDO2 and OpenPGP)**, and the SOP requires
     immediate reporting of a lost token or locked PIN;
   - (e) device testing: CI verification of every signature exercises the
     token each time it is used; the SOP adds an initial check at issuance
     and periodic test signatures.
6. *Proving the PIN was used.*  With FIDO2 keys (`ed25519-sk`), each
   signature records whether the user was present and verified.  Generating
   the key with `-O verify-required` makes the token insist on the PIN.  In
   OpenSSH 9.6, though, `ssh-keygen -Y verify` does not let the allowed-signers
   file *require* the verified flag, so CI parses the signature and checks the
   flag itself (a small, testable check; the signature format is documented by
   OpenSSH **(verify)**).  An auditor can then confirm from any signature that
   the PIN was entered.  With OpenPGP cards the PIN is enforced by the card
   but leaves no such evidence, which is one reason to prefer FIDO2 keys.

**Revocation, combining rows 4 and 5.**  Because the allowed-signers file
accepts `valid-before`, and `ssh-keygen -Y verify` accepts a `verify-time`
option ("a time to use when validating signatures instead of the current
time"), CI can verify each signature *as of its trusted timestamp* (row 4).
A signature timestamped before a key's revocation then verifies; one
timestamped after does not.  This uses standard OpenSSH features with no
custom revocation logic.

**The other signer options against row 5.**

- *Software SSH key with passphrase:* the passphrase can serve as the
  password, but nothing enforces a prompt per signing (`ssh-agent` caches),
  nothing proves one occurred, and the key can be copied.  Meets 11.200 only
  as a matter of policy.
- *gitsign:* depends on the identity provider forcing a fresh login for each
  signing (in OpenID Connect terms, a request with `prompt=login` or
  `max_age=0`); whether gitsign can request this, and whether an
  institution's provider honours it, needs checking **(verify)**.  Its
  optional credential cache must be off.

**Residual risk: "what you see is what you sign".**  The token has no screen,
so it signs whatever the helper sends it.  Malware that controls the signer's
computer could show one document and have the token sign another; the touch
requirement stops silent signing but not a deceived signer.  Mitigations: the
helper shows the content hash, which CI and the pull request also display, so
a mismatch is visible; reviewers read the change in the forge's web
interface, not only on their own machine; and CI checks that each signature
covers exactly the content in the pull request.  This risk is shared by
essentially all electronic-signature systems and is worth stating, not
solving.

**Status of row 5: solved by design (hardware token, FIDO2 preferred).**  Each
signature requires PIN and touch; issuance and registry controls preserve
two-person misuse; 11.300's device and loss requirements map onto registry
entries, `valid-before` dates and SOP procedures; and with FIDO2 keys the PIN
can be proven from the signature by a CI check.  Open: FIDO2 vs OpenPGP
(FIDO2 recommended), PIN-retry counts, and the regulatory judgment on token
plus PIN.

### 5.6 Row 6: Manifestation in Human-Readable Form (11.50(b))

**The requirement.**  The printed name, date and time, and meaning "shall be
subject to the same controls as for electronic records and shall be included
as part of any human readable form of the electronic record (such as
electronic display or printout)" (11.50(b)).  Two parts, then:

1. the three items must appear wherever a person reads the record, on screen
   or on paper;
2. the displayed items must themselves be controlled: not something anyone
   could type or alter.

A related requirement is 11.10(b): "The ability to generate accurate and
complete copies of records in both human readable and electronic form
suitable for inspection, review, and copying by the agency."

**Where a person can read a controlled document in this system.**

1. The markdown source, viewed in the forge's web interface (an "electronic
   display").
2. A rendered PDF or docx, produced by CI (the pitch's `render.bash` approach).
3. A printout of that rendered copy.
4. Git's own views (`git log`, `git show`, the forge's tag page).

**What git plus a forge provides.**  Forge approvals appear only on the pull
request page, not on the document.  The rendered copies carry no signature
information (obs-qms docx exports today show a blank Approvals table).  And
the markdown source *cannot* show signatures, because writing them into the
file would change its content and break them (Section 5.3.1).

**How the design addresses it.**

1. *The rendered copy is the human-readable form of record.*  CI renders each
   document version and fills the Approvals table from the verified signature
   tags (Section 5.3.1).  For each required role, the row shows:

   | Role | Name | Signature / Date |
   |------|------|------------------|
   | Author | Paul Wighton | Electronically signed (Authorship), 2026-10-22 14:51:12 UTC |
   | Approver | Alice Smith | Electronically signed (Approval), 2026-10-22 15:04:07 UTC |
   | QA Representative | Bob Jones | Electronically signed (QA Approval), 2026-10-22 15:22:40 UTC |

   with a footnote giving each meaning's definition, the document's content
   hash, and the signature tag names, so any reader can verify the copy
   against the repository.
2. *Every displayed value is controlled.*
   - The *printed name* comes from the signer registry, which is under change
     control.  The render uses the registry *as it stood at the signing time*
     (its git history records this), so a later change (e.g. a name change
     after marriage) does not alter past signatures.
   - The *date and time* is the TSA time (row 4), shown in UTC with the time
     zone stated.
   - The *meaning* is the field inside the signed tag (row 3).
   - CI fills the table only from signatures it has verified, and it is the
     only thing that fills it.
3. *Unsigned documents look unsigned.*  If a version lacks any required
   signature, the render marks it clearly (e.g. a "DRAFT: NOT APPROVED"
   watermark and blank signature rows), so an unapproved document cannot be
   mistaken for an approved one.
4. *The source view points to the rendered copy.*  The markdown source shown
   in the forge cannot display signatures.  Two complementary measures:
   - the electronic-signature and document-control SOPs designate the
     rendered copy as the human-readable form of the record, and the source
     as its editable form;
   - the source's Approvals table can carry a fixed line such as
     "Signatures: see the rendered copy" (static text that never changes, so
     it does not affect signatures), and CI publishes the rendered copies
     where staff read them (for example as forge releases or a documentation
     site).
   Whether designating the rendered copy is sufficient for "any human
   readable form" is a judgment to record in the SOP; the forge's tag page
   also displays each signature's message (signer, meaning, date) and, for
   registered SSH or GPG keys, a "Verified" badge, which is a second
   electronic display of the manifestation.
5. *Copies stay accurate (11.10(b)).*  The rendered PDF is a *copy*: someone
   could edit a PDF after rendering.  Because it prints the content hash and
   tag names, anyone can check it against the repository.  Optionally CI can
   also sign the PDF itself (e.g. a PDF digital signature) so that tampering
   with the file is detectable without the repository.  The pitch's Section
   5.1 rule still applies: printed or downloaded copies are marked
   uncontrolled, with the current version on `main`.

**Status of row 6: solved by design.**  The rendered copy shows printed name,
trusted date and time, and meaning for every required role, all drawn from
verified, controlled data, with verification details and a clear draft
marking.  Open: where rendered copies are published; whether CI signs PDFs;
SOP wording designating the rendered copy as the human-readable form.

## 6. Considered Approaches

### 6.1 A metadata file in the repository

**Proposal.**  For each controlled document, keep a companion file in the
repository recording its approvals, for example `SOP-002.approvals.yaml`:

```yaml
- revision: 4
  pull_request: 42
  reviewer: alice
  state: APPROVED
  commit: abc123
  submitted_at: 2026-10-22T15:04:00Z
```

**What it fixes.**  It moves the approval record from the forge's database
into git:

1. It travels with every clone, mirror and backup, so nothing is lost when
   changing forge (fixes row 2, gap 3).
2. Later changes to it are visible in git history, so a retroactive edit is
   tamper-evident instead of silent (partly addresses row 2, gap 2).
3. It can be per document and rendered into each document's signature block
   (addresses row 2, gap 5).

**What it does not fix.**  The file is plain text.  Anyone who can commit to
the repository can write `reviewer: alice, state: APPROVED`.  Git history
shows that the line was added, but a commit's author name is free text, so it
cannot prove Alice wrote it.  The file records a *claim*, not *proof*.

- If people write their own entries, Paul can write Alice's.
- If a CI bot copies approvals from the forge, the file is only as
  trustworthy as the forge's database at the moment of copying, plus the bot
  (anyone who can change its configuration or obtain its credentials can make
  it write anything), and the bot itself needs validating.

It also fails 11.70 directly: copying Alice's entry from one document's
approvals file to another's is a copy and paste, an ordinary means of
transferring a signature.  The entry mentions a commit hash, but nothing
binds the entry to that hash.

**Conclusion.**  A metadata file is the right *content* for an approval
record, but it needs a *signature over it* to become proof.  A signed tag
(Section 6.2) is exactly such a record with a signature attached.  The
metadata file remains useful as a human-readable index generated by CI from
verified signatures (Section 7.6).

### 6.2 Signed tags on document content

**Proposal.**  Each signature is an annotated tag, signed with the signer's
key, pointing at the *blob* of the document being signed (its exact content),
with a structured message:

```
Document: SOP-002 Document and Records Control, Rev 4
Path:     SOP-002--Document_and_Records_Controls_Procedure.md
Signer:   Alice Smith <alice@example.edu>
Meaning:  Approval
Signed-At: 2026-10-22T15:04:00Z
```

**How it addresses row 2.**

| Gap | How the signed tag addresses it |
|---|---|
| Transfer to new content | The signature covers the content hash.  Any change produces a new hash, so the old signature no longer verifies, regardless of forge settings |
| Database record | The link is cryptographic: anyone can check it with `git verify-tag` and the signer registry |
| Lost on migration | Tags travel with every clone and mirror |
| Squash/rebase merges | The *content* on `main` is identical whatever the merge method; CI checks that each document on `main` matches a signed blob |
| Whole-change approval | One signature per document revision; the message names the document and revision |

**Why the blob and not the commit.**  Signing a commit signs a snapshot of the
whole repository, so approving one SOP would appear to approve everything in
it, and a merge or rebase creates new commits that the signature does not
cover.  A blob is exactly one document's content, and it is unchanged by how
the pull request is merged.

**Residual issue: deleting a tag.**  Deleting Alice's tag does not falsify the
document, but it removes the evidence that she signed ("excised").
Mitigations: forges support **protected tags** that ordinary users cannot
delete; CI on `main` refuses approved revisions that lack their required
signatures; mirrors and backups keep tags.  Deletion then becomes detectable.

**Residual issue: identical content under another name.**  Two files with
byte-identical content share a blob hash, so a tag could in principle be
presented as covering the other file.  The tag message names the document
and path, and CI checks that these match.

### 6.3 Signed commits to a metadata file (variant)

Alice could instead add her own entry to the approvals file in a commit
signed with her key.  This also produces proof, but:

1. her commit changes the pull request, so on forges that discard stale
   approvals, Bob's forge approval resets (signatures on the SOP's blob are
   unaffected, since the SOP's content has not changed);
2. simultaneous signers produce competing commits to the same file, and one
   must redo theirs.

Tags are separate objects that change no files, so neither problem arises.

### 6.4 Comparison with Commercial E-Signature Services

**Ordinary use is not Part 11 mode.**  When someone receives a DocuSign
envelope by email, clicks the link, types their name and clicks "Sign", the
only evidence of identity is access to their email inbox: one factor, with
nothing re-entered at signing.  That is valid for contracts, leases and HR
forms, which fall under general e-signature laws (in the US, the ESIGN Act
and UETA), not under Part 11, which applies only to records required by FDA
regulations.

**The vendors sell a separate Part 11 configuration**, which adds the
controls analysed in Section 5 (checked 2026-10-22 from institutional guides
and vendor documentation):

- *DocuSign Part 11 module.*  UCSF's guide for its staff: the signer selects a
  reason for signing from a dropdown (usually "I approve this document"),
  then "will be redirected back to the login page where they will have to
  authenticate again", including for each initials field.  A Saint Louis
  University training handout shows the signature frame carrying the signing
  reason, date and timestamp.  A DocuSign community answer (not official
  documentation) says signers need only a DocuSign account, possibly a free
  one, not a Part 11-enabled account.
- *Adobe Acrobat Sign "Bio-Pharma" settings.*  "Enforced identity
  authentication", requiring signers to "re-authenticate themselves every
  time they apply their signature", and a signing-reason option; signature
  blocks are timestamped.  Only account administrators can enable them.
- *Box Sign* offers Part 11 signature requests, and recently added
  re-authentication and signing reasons for initials fields after previously
  omitting them.

**How they meet the rows.**  Two components = username + password, re-entered
at the signing moment (row 5); meaning = signing reason (row 3); date and
time = server timestamp (row 4); manifestation = signature frame on the
document (row 6); linking = the vendor's certified PDF with its own
tamper-evident seal (row 2).

**"Compliant" is shared.**  Neither vendor claims its product is compliant on
its own.  Adobe's Part 11 white paper frames compliance as shared between
Adobe and the customer and achievable only with proper implementation.  The
customer still validates the configuration, writes SOPs, verifies signer
identities and sends FDA the certification letter (11.100(c)).  The same is
true of this design.

**Implications for this design.**

1. *Part 11 does not require a hardware token or a PIN.*  Password re-entry at
   a trusted server is the conventional approach.  The token is a stronger
   choice, recommended because it removes the need to trust any server and
   suits an open, self-hosted design (Section 7.2).
2. *Server-side signing is the market norm, not an outlier.*  Its risk
   (the operator could sign as anyone) is accepted when the operator is an
   independent, audited third party (Section 7.5, item 4).
3. *A practical hybrid.*  An institution with an existing validated DocuSign
   or Adobe Part 11 account can use it for the signing step only: sign a PDF
   rendered from a specific git version, with the document's content hash
   printed on it, while the QMS stays in git.  Less elegant (signatures live
   outside git, and the link back to the git content is via the printed
   hash), but a realistic adoption path: "Tier 3 today via an existing
   validated e-signature service; natively in git later".

**Sources.**  UCSF IT, "Signing a 21 CFR Part 11 compliant document in
DocuSign" (https://it.ucsf.edu/how-to/signing-21-cfr-part-11-compliant-document-docusign);
SLU DocuSign training handout
(https://mph.slu.edu/medicine/research/-pdf/docusign-training-handout.pdf);
Adobe Acrobat Sign Bio-Pharma settings
(https://helpx.adobe.com/sign/help/adobesign_bio-pharma.html); Adobe Sign 21
CFR Part 11 white paper
(https://adobe.com/content/dam/cc/en/security/pdfs/adobe-sign-compliance-21CFRpt11-wp-ue.pdf);
Box Sign support article
(https://support.box.com/hc/en-us/articles/30096284694163-Support-for-21-CFR-Part-11-initials-field-in-Box-Sign).

### 6.5 The Solution Space for Authentication

**Hardware tokens are not required.**  Only two of the six rows depend on how
the signer authenticates: row 1 (identity) and row 5 (authentication at the
moment of signing).  Rows 2, 3, 4 and 6 (linking, meaning, time and display)
come from *what* is recorded: a record naming the exact content, the meaning
and the signer, with a trusted timestamp, rendered into the Approvals table.
That evidence format works the same whatever authentication sits underneath.

So the question reduces to: *at the moment of signing, what confirms that the
right person, using two components, approved this exact content, and what
evidence of that is left behind?*  There are three families of answer.

#### Family A: the signature is made on the signer's own device

The signer's computer, phone or token makes a cryptographic signature.  The
options differ in where the private key lives and how it is unlocked.

- **A1. Software key with passphrase.**  Key in a file on the laptop,
  unlocked by a passphrase if the user keeps one.  Free; the passphrase can be
  neither enforced nor proven, and the file can be copied (Section 7.2).
- **A2. Dedicated hardware token** (FIDO2 security key, OpenPGP card, PIV smart
  card).  Key inside the token, cannot be copied out; unlocked by PIN, plus
  touch.  Costs a device per person.  With FIDO2, the PIN is provable from the
  signature (Section 5.5).
- **A3. Hardware built into the computer** (a TPM chip on Windows and Linux,
  the Secure Enclave on Macs).  Key inside the chip, cannot be copied out;
  unlocked by PIN or by fingerprint or face (Windows Hello, Touch ID).  No
  device to buy, since most modern laptops have one.  Tools exist (for
  example Secretive on Macs, and TPM-backed SSH agents) **(verify)**, but they
  generally do not record "PIN entered" in the signature as FIDO2 does: the
  authentication is enforced, but not provable from the signature.
- **A4. A phone as the authenticator** (passkeys, via the browser's WebAuthn).
  Key in the phone's secure hardware, unlocked by the phone's PIN or
  biometric.  Pairs naturally with a web signing page (Section 7.5); WebAuthn
  assertions carry a user-verified flag.  *Synced* passkeys (iCloud, Google)
  are copied across the user's own devices, so "cannot be copied" weakens to
  "only the user's own devices"; device-bound passkeys avoid this.
- **A5. gitsign.**  A temporary key, discarded after signing; authentication
  is a login to the institution's identity provider.  Meets row 5 only if
  the provider forces a fresh login (Section 5.5).

*Biometrics.*  Part 11 has a separate rule for biometric signatures
(11.200(b)): they must be "designed to ensure that they cannot be used by
anyone other than their genuine owners".  When a fingerprint or face merely
*unlocks* a key (A3, A4), the signature itself is still key-based, so which
rule applies is debatable.  Record as a regulatory question rather than rely
on it.

#### Family B: a trusted server re-authenticates the signer

The signer proves who they are *to a server* at the moment of signing.  The
server records the approval and seals it with *its own* key: in effect, "Alice
re-authenticated at 15:04 and approved content `3f9c2a…` with meaning
Approval".  That record can still be a signed tag on the document's content,
signed by the server instead of by Alice, so rows 2, 3, 4 and 6 work as
before.

- **B1. Commercial e-signature service** (DocuSign or Adobe Part 11 mode;
  Section 6.4).  Run by an independent, audited vendor; the conventional
  approach.  Signatures live outside git, linked by the content hash printed
  on the signed PDF.
- **B2. A small self-hosted signing service.**  A web page: log in again
  (password, or single sign-on with forced re-authentication and MFA), view
  the document, choose a meaning, click Sign.  Web-only, no hardware, nothing
  to install.  But the people who run it could in principle sign as anyone,
  so it needs procedural controls (separated administration, append-only
  logs, trusted timestamps, possibly a public transparency log), and it is new
  software to validate.
- **B3. Re-authentication added to the forge.**  No major forge is known to
  ask for a password again when someone approves a pull request **(verify)**.
  Gitea and Forgejo are open source, so a "re-enter your password to approve"
  feature could be contributed upstream.  Their approvals would then meet
  row 5 directly, with a server-signed record in git for rows 2 to 6.  A
  genuine opportunity, and a "contribution, not concession" story for the
  pitch.

In Family B, trust moves from the signer's device to the server operator.
Every commercial Part 11 system works this way, so this is acceptable; it
must be managed.

#### Family C: handwritten signatures on a rendered copy

Part 11 explicitly covers "handwritten signatures executed to electronic
records" (11.70), which must be linked to the record so they cannot be
transferred.  So the lowest-technology option is:

1. CI renders the document version as a PDF with its content hash printed on
   every page;
2. the signers sign the printout by hand;
3. the scan is committed to the repository, and CI checks that the hash on
   the scan matches the document.

This "hybrid" approach (electronic record, handwritten signature) is common in
regulated work.  No infrastructure, keys or new software; works from day
one.  Clunky, slow and paper-based, but a legitimate floor, and possibly the
honest answer for Tier 3 until something better is in place.

#### Comparison

| | Two components enforced at every signing? | Provable from the evidence? | Key can be copied? | Trusted party needed? | Extra infrastructure | Web-only? |
|---|---|---|---|---|---|---|
| A1 Software key | Policy only | No | Yes | No | None | No |
| A2 Hardware token | Yes | Yes (FIDO2) | No | No | Tokens + helper | Via WebAuthn page |
| A3 Built-in TPM / Secure Enclave | Yes | Mostly not | No | No | Helper | Via WebAuthn page |
| A4 Phone passkey | Yes | Yes (WebAuthn user-verified flag) | Synced: within user's own devices | No | Web signing page | Yes |
| A5 gitsign | Only if the provider forces it | Partly (provider's login records) | No | Sigstore + identity provider | Helper (+ Sigstore) | No |
| B1 Commercial e-signature | Yes | Vendor's audit trail | n/a | Vendor | Existing account | Yes |
| B2 Self-hosted signing service | Yes | Server's logs | n/a | Institution's admins | Small web service | Yes |
| B3 Forge re-authentication | Yes | Server's logs | n/a | Forge admins | Upstream contribution | Yes |
| C Handwritten + scan | Yes (ink) | Yes (physical signature) | n/a | No | None | No |

#### What "minimal" means depends on the cost being minimised

- Least infrastructure: C, or B1 if a commercial account already exists.
- Least for users to install (web-only signing): A4, B2 or B3.
- Least trust in anyone: A2, or A3 if built-in hardware is acceptable.
- Strongest evidence for an auditor: A2 with FIDO2 (PIN provable from the
  signature).

#### Implication for the pitch

Section 8.1 should not say the design *requires* hardware tokens.  Suggested
framing: the evidence format (signed tags on document content, trusted
timestamps, render-time signature blocks) is fixed and solves linking,
meaning, time and display; how the signer authenticates is a choice: hardware
tokens or built-in device keys for the strongest, server-free option; a
re-authenticating signing service (self-hosted, or contributed to the
open-source forges) for web-only signing; or handwritten signatures on
rendered copies as a zero-infrastructure floor.

## 7. Design

### 7.1 Three independent dimensions

The design involves three separate choices, which combine:

1. **How the signer proves who they are** (where the key comes from): a
   software SSH key with a passphrase, a hardware token, or gitsign.  This is
   the decision that matters most for Part 11 (Section 7.2).
2. **What form the signature takes**: a native signed git tag, or a detached
   signature file (Section 7.3).
3. **What the signer uses**: a command-line helper, a desktop app, or a web
   page (Section 7.5).

Not every combination works (for example, gitsign signs git objects, so
detached signatures would need a different Sigstore tool).

### 7.2 Signer identity options

**Option 1: software SSH key with a passphrase.**  Each signer generates an
ordinary SSH key on their laptop, protected by a passphrase.  Free and easy.
The key plus passphrase is close to Part 11's own example ("an identification
code and password").  Weaknesses:

- the organization cannot verify a passphrase is used at all: it is set on
  the user's machine, can be weak or absent, and can be removed later with
  `ssh-keygen -p`; signatures look identical either way;
- `ssh-agent` normally caches the unlocked key, so later signings are silent;
  the helper can bypass the agent, but nothing enforces that;
- the key is a file and can be copied (backups, synced folders, malware,
  laptop administrators); a copied key plus a keylogged passphrase lets one
  person sign as another (11.200(a)(3));
- passphrase management (11.300) is outside the organization's control.

**Option 2: hardware token.**  The private key is generated inside a USB or
NFC security key (e.g. YubiKey, Nitrokey) or smart card and cannot be copied
out.  The device signs, and can require a PIN (and a touch) for *every*
signature: OpenPGP cards have a "force signature PIN" setting; FIDO2-backed
SSH keys have a "verify-required" option.

- Two components at every signing: the token (have) and the PIN (know).
- Misuse needs the token *and* the PIN; a forge administrator cannot sign as
  someone else, because the key is not on any server.
- **Provable per-signing authentication (FIDO2 keys only):** FIDO2
  security-key signatures (`ed25519-sk`, `ecdsa-sk`) record flags showing
  that the user was present (touch) and verified (PIN).  A key generated
  with `-O verify-required` makes the token demand the PIN for every
  signature.  *Correction (2026-10-22):* in OpenSSH 9.6 the allowed-signers
  file does **not** accept a `verify-required` option (only `cert-authority`,
  `namespaces`, `valid-after`, `valid-before`), so `ssh-keygen -Y verify`
  will not by itself reject a signature without the PIN flag.  CI must read
  the flag from the signature directly (see Section 5.5) **(verify whether
  later OpenSSH versions add this)**.  OpenPGP cards' "force signature PIN"
  is enforced by the card but leaves no evidence in the signature.
- Works offline and with any forge.
- Costs: roughly $25–80 per token **(verify)**; token issuance, loss and
  revocation; command-line setup is a hurdle for non-technical staff; the
  signature carries only the signer's own clock time.

**Option 3: gitsign (Sigstore).**
[gitsign](https://github.com/sigstore/gitsign) does "keyless" signing.  At
signing, a browser opens for a login through an OIDC identity provider;
Sigstore's certificate authority (Fulcio) issues a certificate valid for about
10 minutes that binds a temporary key to the verified email identity; the tag
is signed; the signature is recorded in the Rekor transparency log with a
timestamp.  From the README (checked 2026-10-22):

- signs tags as well as commits;
- self-hosted Sigstore instances are supported;
- an optional credential cache means one login per certificate lifetime
  (the helper should leave it off);
- `git verify-tag` warns that it "does not verify cert claims", so CI needs
  `gitsign verify` to confirm *who* signed;
- GitHub does not show gitsign signatures as Verified;
- on the public instance, log entries contain the certificate, which "may
  include user emails or repo identifiers".

Strengths: no keys to manage, identity from the institution's existing login,
and a trusted timestamp.  Weakness for 11.200: if the browser already has a
single-sign-on session, the login can complete silently, so re-authentication
at each signing depends on the identity provider being configured to force a
fresh login.

**Comparison.**

| | Software key + passphrase | Hardware token + PIN | gitsign + SSO |
|---|---|---|---|
| Cost and setup | Free, easiest | ~$25–80/person; token issuance | Free; depends on SSO |
| Per-signing authentication | Policy only | Enforced and provable | Only if SSO forces it |
| Key can be copied | Yes | No | No (temporary keys) |
| Trusted timestamp | No | No | Yes (Rekor) |
| Third-party dependency | None | None | Sigstore (or self-host) |

**Recommendation.**  The hardware token is the only option that *guarantees*
per-signing authentication independently of the forge, the identity provider
or any outside service, and that lets an auditor verify it from the
signature.  It is the recommended minimal design.  Note that Part 11 does
not require a token: the industry-standard way to meet 11.200 is re-entering
a username and password at a trusted server at the moment of signing
(Section 6.4).  The token is *stronger* than that norm (possession plus
knowledge, no trusted server, works offline), not the minimum the regulation
demands, and the pitch should not imply that anything less is
non-compliant.  The software key is a
lower-cost alternative an institution may accept under a risk-based approach
(e.g. for records not submitted to regulators).  gitsign is an alternative
for institutions whose single sign-on can force re-authentication.

### 7.3 Signature form

**Native signed tag** (recommended): verified with standard `git verify-tag`;
needs the signed object in a local repository (Section 7.4).

**Detached signature**: SSH keys (including hardware-token keys) can sign
arbitrary data with `ssh-keygen -Y sign`.  The helper downloads the document
through the forge's API, computes its git blob hash locally, signs a short
statement containing the hash, document, signer and meaning, and uploads the
signature to the pull request, where a CI bot commits it.  No git needed on
the signer's machine, and the signature still binds to exact content.  Costs:
not a native git object (CI verifies with `ssh-keygen -Y verify`), and the
bot is one more component to validate.  This is the stepping stone to
web-based signing (Section 7.5).

### 7.4 Signers do not clone the repository

Creating a native signed tag requires the signed object in a local
repository.  The helper handles this invisibly:

1. create a temporary empty repository;
2. fetch only the pull request's latest commit, with no history (a one-commit
   shallow fetch, optionally a partial fetch of just the one file).  Forges
   expose pull requests under predictable names: GitHub `refs/pull/42/head`,
   GitLab `refs/merge-requests/42/head`, Gitea and Forgejo
   `refs/pull/42/head`;
3. show the signer what they are about to sign;
4. create the signed tag, push only the tag, delete the temporary directory.

### 7.5 Signer interface

1. **Command-line helper** (`qms-sign approve 42`): minimal; recommended for
   the first implementation.
2. **Desktop app** with a "Sign this pull request" button doing the same: no
   command line, still installed locally.
3. **Web page using WebAuthn**, the browser standard behind passkeys:
   browsers can already ask a hardware token to sign data with PIN and touch.
   A page could show the document and have the token sign its content hash.
   Fully web-based, as strong as Option 2, but produces a detached signature
   (stored by a bot) and is a new component to validate.  Roadmap item.
4. **Server-side signing service** (not recommended for the core design): the
   server re-authenticates the user (forced re-login) and applies the
   signature on their behalf.  Easiest for users, and in fact the
   conventional approach: commercial Part 11 services such as DocuSign and
   Adobe Acrobat Sign work this way (Section 6.4).  But whoever runs the
   server could in principle sign as anyone (11.200(a)(3)).  The market
   accepts that risk when the operator is an independent, audited third
   party; an institution running its own service would have to address the
   administrator problem itself, and it adds infrastructure to validate.  For
   an open, self-hostable, minimal design, hardware tokens avoid the need to
   trust any server.  Using an existing validated commercial service for the
   signing step is, however, a legitimate interim path (Section 6.4).

Signing cannot currently be done purely in the forge's web interface: commits
made in a web editor are signed by the *forge's* key, which proves the forge
made the commit, not that the user approved it.

### 7.6 Components

1. **Signed tags on document blobs**, one per signature (Section 6.2).
2. **Signer keys on hardware tokens**, PIN and touch required per signature
   (Section 7.2).
3. **A signer registry under document control**: an `allowed_signers` file
   (SSH) or keyring mapping each key to a verified person and legal name,
   changed only by approved pull request, with the identity check recorded at
   issuance (11.100(b)).  Revoking a key is a commit; earlier signatures stay
   verifiable against the registry as it stood when they were made.
4. **A trusted timestamp** for each signature (row 4, to analyse): an RFC 3161
   timestamping authority (token stored with the tag, e.g. as a `git note`),
   or gitsign's transparency log.
5. **CI verification**: checks each signature against the registry, the
   message fields, the timestamp, and that the signed blob matches the
   document in the pull request and later on `main`; blocks merging until the
   required signatures are present and valid.
6. **Rendering**: the export step prints a signature block (printed name, date
   and time, meaning) into every rendered copy (11.50(b)); CI can also
   generate a human-readable approvals file from the verified tags
   (Section 6.1).
7. **Protected tags** so ordinary users cannot delete signatures.
8. **An electronic-signature SOP**: what each meaning signifies; key issuance,
   revocation and loss; training; and the one-time certification letter to
   FDA (11.100(c)).

## 8. Workflow: Paul Edits, Alice and Bob Approve

`qms-sign` is a hypothetical helper to be written.

**Same under all options (browser only).**

1. Paul opens `SOP-002.md` in the forge's web editor (or locally), edits it on
   a new branch, and opens pull request 42, requesting Alice and Bob as
   reviewers.
2. CI checks formatting and renders a preview PDF.
3. Alice and Bob read the line-by-line diff in the browser, comment, and ask
   for changes; Paul pushes fixes.  The discussion is recorded with the pull
   request.

**Signing with a hardware token.**  One-time setup per signer (with QA):
install git and the helper; generate a key on the token; QA verifies identity
and adds the public key and legal name to the registry by pull request.  Then:

1. Alice runs `qms-sign approve 42`.
2. The helper fetches pull request 42 into a temporary repository and shows:
   ```
   Document: SOP-002 Document and Records Control, Rev 4
   Content:  blob 3f9c2a…
   Meaning:  Approval
   Sign as Alice Smith? [y/N]
   ```
3. The token asks for her PIN, then waits for a touch.
4. The helper pushes the signed tag.  The pull request shows "Signatures: 1 of
   2".
5. Bob does the same; CI verifies both; the check turns green; the pull
   request can merge.  The forge's own "Approve" button becomes optional.

If Paul pushes a change after Alice signs, the document's content hash
changes, her signature no longer matches, and she must sign again.

**Signing with gitsign.**  Setup: install git, gitsign and the helper; the
registry maps institutional emails to legal names.  At step 3, a browser
opens to the institution's single-sign-on page for password and MFA (only
reliably if IT forces a fresh login); the signature is recorded in the
transparency log with a timestamp.  Otherwise the same.

**Who needs this.**  Only people whose approval is a regulated signature (QA,
document owners) need tokens and the helper.  Everyone else reviews in the
browser.

## 9. Open Questions and Items to Verify

- Section 6.5: platform-authenticator tools (Secretive, TPM-backed SSH
  agents, Windows Hello with OpenSSH) and whether any record user
  verification in the signature; whether any forge re-prompts for a password
  on approval; regulatory view of biometric unlock (11.200(b)).
- Row 6: where rendered copies are published; whether CI signs PDFs; SOP
  wording designating the rendered copy as the human-readable form.
- Row 5: FIDO2 vs OpenPGP tokens (FIDO2 recommended); PIN-retry counts;
  whether gitsign can force fresh login (`prompt=login`/`max_age=0`).
- Row 4 choices: which TSA; token storage (note, tag or file); timestamp
  merges on `main` too?  Verify free TSA terms of use, git-notes display and
  protection on forges, GitHub events retention, Sigstore timestamp service,
  OpenTimestamps git integration.
- Records stored as issues: option (a), (b) or (c) (Section 5.2 status).
- Effective date: set before signing (a) or kept out of the file and filled
  at render time (b) (Section 5.3.1).
- Whether GitLab stores the approval-rule name with each approval.
- FDA's 2003 *Scope and Application* guidance: confirm which provisions are
  under enforcement discretion.
- Whether FDA accepts a hardware token plus PIN as "two distinct
  identification components" (regulatory judgment; Part 11's example is an
  identification code and password).
- GitHub "sudo mode" scope; administrator impersonation on GitLab and GitHub
  Enterprise Server.
- Each forge's default for discarding stale approvals.
- Format of the FIDO2 flags in SSH signatures (for the CI check, Section
  5.5); whether newer OpenSSH versions accept `verify-required` in the
  allowed-signers file.
- Current forge support for SHA-256 repositories.
- Hardware token prices.
- Whether to offer the software-key and gitsign options as site choices.

## 10. References

- 21 CFR Part 11, current eCFR text:
  https://www.ecfr.gov/current/title-21/chapter-I/subchapter-A/part-11
- gitsign: https://github.com/sigstore/gitsign
- Sigstore: https://www.sigstore.dev/
- RCPCH QMS (a live git-native ISO 13485 QMS):
  https://growth.rcpch.ac.uk/safety/qms/
