include $(top_srcdir)/Makefile.decl

SRC_DIR = $(top_srcdir)/gee

docdir=$(datadir)/devhelp/references/gee-1.0
innerdocdir=$(datadir)/devhelp/references/gee-1.0/gee-1.0
imgdir=$(datadir)/devhelp/references/gee-1.0/gee-1.0/img

doc_data = \
	gee-1.0/*.css \
	gee-1.0/*.png \
	$(NULL)

doc_DATA = \
	gee-1.0/index.html \
	$(doc_data) \
	$(NULL)

innerdoc_DATA = \
	gee-1.0/gee-1.0/index.htm \
	gee-1.0/gee-1.0/*.html \
	$(NULL)

img_DATA = \
	gee-1.0/gee-1.0/img/*.png \
	$(NULL)

$(doc_data) $(innerdoc_DATA) $(img_DATA): gee-1.0/index.html

gee-1.0/index.html:
	$(VALADOC) -o gee-1.0/ --wiki ./ --force -b $(top_srcdir) $(SRC_DIR)/*.vala

EXTRA_DIST += \
	index.wiki \
	$(NULL)
