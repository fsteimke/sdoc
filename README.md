# Real life test of xslTNG Stylesheet for publishing DocBook Documents

Testing the migration of DocBook publishing from XSL Stylesheets 1.0
to the new xslTNG Stylesheets with a huge DocBook set full of Books.

[SUSE](https://www.suse.com/) is a provider of an Enterprise Linux
distribution. The Documentation for the software is online at
[documentation.suse.com](https://documentation.suse.com). The books
and articles exist as XML sources, conformant to the DocBook
standard. You can find the [sources at
GitHub](https://github.com/SUSE/doc-sle). SUSE publishes them with the
DocBook XSLT 1.0 Stylesheets, which generate XSL-FO, and Apache FOP,
which in turn generates PDF and HTML.

The XSL Stylesheets are very old. They are based on the 1.0 Version of
XSLT from end of 1999. But they are still used because extensive
documentation systems such as SUSE's are based on them. Newer versions
of the style sheets are available, but how much effort would migration
require?

To answer this question, I took the same sources, but published them
with the new [xslTNG Stylesheets](https://xsltng.docbook.org) from
Norman Walsh, which are based on XSLT 3. They transform DocBook XML
documents into clean, semantically rich HTML5. Producing high quality
print output with a paged media capable CSS processor is also
supported, but a CSS rendering engine is required.

Transformation is done in an Ubuntu Linux Environment. The current
configuration is

- DocBook xslTNG 2.7.0
- CSS to PDF with [Weasyprint 61.1](https://weasyprint.org/)

Customization is done in a Framework which uses XProc for additional
steps (e.g. copying media files). It uses [xmlcalabash
3.0.25](https://codeberg.org/xmlcalabash/xmlcalabash3).


**Since this is a test, the PDF documents may contain errors. Please
look at them only as test results, and do not rely on their content.**

## Directory structure

- `doc-sle-15SP7` Snapshot of SUSE original documentation. Contains
  SUSE's DocBook sources in `xml` and puplished PDF in `pdf`.
  
- `migration` Stylesheetes to generate the DocBook sources that are
  used for publishing with xslTNG. The main differences against SUSE's sources are
  
  - **non profiled DocBook:** SUSE's sources contain uses DocBook
    effectivity attributes for conditional text, see ["Effectivity
    attributes and
    profiling"](https://xsltng.docbook.org/guide/2.7.0/ch-using#profiling). This
    allows to cover different architectures and software products with
    only one DocBook source file, but adds a level of complexity. To
    reduce complexity, my sources are non profiled.
	
  - **new Syntax for cross references:** The Syntax for `xrefd/@xrefstyle` is not part of the DocBook standard. See ["Customize individual
    cross
    references"](https://xsltng.docbook.org/guide/2.7.0/ch-using#customize-individual-cross-references).
	
- `src` The DocBook sources for the published Books

- `custom` Customization of xslTNG Stylesheets

- `pdf` The Books that are published from the DocBook sources in `src`
  with xslTNG 2.7.0. Their content should be identitcal to to
  corresponding book in `doc-sle-15SP7/pdf`, and the loyout should be
  very similar.
  
## Published Dokuments

You will find published Documents not only in the `pdf` directory, but
also at my GitHub Pages:

- [Quick Start Guides](https://fsteimke.github.io/xsltng-docs/suse/book-quick-start.pdf)
- [Administration Guide](https://fsteimke.github.io/xsltng-docs/suse/book-administration.pdf)
- [AutoYast Guide](https://fsteimke.github.io/xsltng-docs/suse/book-autoyast.pdf)
- [Deployment Guide](https://fsteimke.github.io/xsltng-docs/suse/book-deployment.pdf)
- [GNOME User Guide](https://fsteimke.github.io/xsltng-docs/suse/book-gnome-user.pdf)
- [RMT Guide](https://fsteimke.github.io/xsltng-docs/suse/book-rmt.pdf)
- [Security and Hardening Guide](https://fsteimke.github.io/xsltng-docs/suse/book-security.pdf)
- [Storage Administration Guide](https://fsteimke.github.io/xsltng-docs/suse/book-storage.pdf)
- [System Analysis and Tunig Guide](https://fsteimke.github.io/xsltng-docs/suse/book-tuning.pdf)
- [Upgrade Guide](https://fsteimke.github.io/xsltng-docs/suse/book-upgrade.pdf)
- [Virtualization Guide](https://fsteimke.github.io/xsltng-docs/suse/book-virtualization.pdf)


