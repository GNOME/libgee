enable_doc = get_option('enable-doc')

if enable_doc
	valadoc = find_program ('valadoc', required: false)
	if valadoc.found()
		outdir ='Gee-'+API_VERSION
		valacapi = run_command ('valac', '--api-version')
		driver = '--driver='+valacapi.stdout().strip()
		pkgname = '--package-name='+'Gee-'+API_VERSION
		pkgversion = '--package-version='+PROJECT_VERSION
		vapidir = '--vapidir='+join_paths (meson.current_source_dir (),'gee')
		vapidirvapi = '--vapidir='+join_paths (meson.current_source_dir (),'vapi')
		docsdir = join_paths (get_option ('datadir'), 'devhelp','books')

		custom_target ('valadocs',
				input : valasources,
				output : outdir,
				command : [valadoc,
					driver,
					'--doclet=devhelp',
					'--force',
					pkgname,
					pkgversion,
					'--pkg=gio-2.0',
					vapidir,
					vapidirvapi,
					'--vapidir', join_paths (meson.source_root (),'utils'),
					'--pkg=geeutils',
					'--directory=@OUTDIR@',
					valasources],
				install : true,
				install_dir : docsdir)
	endif
endif
