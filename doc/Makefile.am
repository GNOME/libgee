include $(top_srcdir)/Makefile.decl

SRC_DIR = $(top_srcdir)/gee

docdir=$(datadir)/devhelp/references/gee-0.8
innerdocdir=$(datadir)/devhelp/references/gee-0.8/gee-0.8
imgdir=$(datadir)/devhelp/references/gee-0.8/gee-0.8/img

doc_data = \
	gee-0.8/*.css \
	gee-0.8/*.png \
	$(NULL)

doc_DATA = \
	gee-0.8/index.html \
	$(doc_data) \
	$(NULL)

innerdoc_DATA = \
	gee-0.8/gee-0.8/index.htm \
	gee-0.8/gee-0.8/*.html \
	$(NULL)

img_DATA = \
	gee-0.8/gee-0.8/img/*.png \
	$(NULL)

$(doc_data) $(innerdoc_DATA) $(img_DATA): gee-0.8/index.html

gee-0.8/index.html:
	$(VALADOC) -o gee-0.8/ --wiki ./ --force -b $(top_srcdir) $(SRC_DIR)/*.vala

EXTRA_DIST += \
	index.wiki \
	$(NULL)
