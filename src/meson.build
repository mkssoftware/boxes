common_sources = [
  'async-launcher.vala',
  'box-config.vala',
  'collection-source.vala',
  'util.vala',
]

vala_args = [
  '--enable-experimental',
  '--vapidir', vapi_dir,
  '--vapidir', join_paths (vapi_dir, 'upstream'),
  '--target-glib=2.38',
]

common_dependencies = [
  config_h,
  config_dep,
  libarchive_dep,
  dependency ('gio-2.0', version: '>= 2.44.0'),
  dependency ('glib-2.0', version: '>= 2.44.0')
]

c_args = [
  '-DDATADIR="' + data_dir + '"',
  '-DGNOMELOCALEDIR="' + locale_dir + '"',
  '-DGETTEXT_PACKAGE="gnome-boxes"',
  '-DCACHEDIR="/var/cache/"',
  '-DG_LOG_DOMAIN="Boxes"',
]

if get_option ('buildtype').contains ('debug')
  c_args += ['-O0', '-ggdb3']
endif

libcommon = static_library(
  'common',
  sources: common_sources,
  include_directories: config_h_dir,
  dependencies: common_dependencies,
  vala_args: vala_args,
  c_args: c_args
)

vala_sources = [
  'app.vala',
  'app-window.vala',
  'actions-popover.vala',
  'archive-reader.vala',
  'archive-writer.vala',
  'collection.vala',
  'collection-toolbar.vala',
  'display-page.vala',
  'display-toolbar.vala',
  'display.vala',
  'downloads-hub.vala',
  'icon-view.vala',
  'installer-media.vala',
  'installed-media.vala',
  'keys-input-popover.vala',
  'libvirt-cloned-media.vala',
  'libvirt-media.vala',
  'iso-extractor.vala',
  'icon-view-child.vala',
  'libvirt-broker.vala',
  'libvirt-machine.vala',
  'list-view.vala',
  'list-view-row.vala',
  'machine.vala',
  'main.vala',
  'media-manager.vala',
  'os-database.vala',
  'portals.vala',
  'search.vala',
  'searchbar.vala',
  'shared-folders.vala',
  'transfer-info-row.vala',
  'troubleshoot-view.vala',
  'topbar.vala',
  'ui.vala',
  'unattended-installer.vala',
  'unattended-file.vala',
  'unattended-setup-box.vala',
  'util-app.vala',
  'vm-configurator.vala',
  'vm-creator.vala',
  'vm-importer.vala',
  'vnc-display.vala',
  'libvirt-vm-cloner.vala',
  'libvirt-vm-importer.vala',
  'welcome-tutorial.vala',
  'welcome-tutorial-page.vala',
  'downloader.vala',
  'tracker-iso-query.vala',
]

subdir('ui')
subdir('assistant')
subdir('preferences')

dependencies = [
  config_h,
  config_dep,
  libarchive_dep,
  dependency ('gobject-2.0', version: '>= 2.44'),
  dependency ('gtk+-3.0', version: '>= 3.22.20'),
  dependency ('gtk-vnc-2.0', version: '>= 0.4.4'),
  dependency ('gvncpulse-1.0'),
  dependency ('libhandy-1', version: '>= 1.5.0'),
  dependency ('libosinfo-1.0', version: '>= 1.7.0'),
  dependency ('libsecret-1'),
  dependency ('libsoup-2.4', version: '>= 2.38'),
  dependency ('libusb-1.0', version: '>= 1.0.9'),
  dependency ('libvirt-gconfig-1.0', version: '>= 4.0.0'),
  dependency ('libvirt-gobject-1.0', version: '>= 4.0.0'),
  dependency ('libxml-2.0', version: '>= 2.7.8'),
  dependency ('tracker-sparql-3.0'),
  dependency ('webkit2gtk-4.0', version: '>= 2.26.0'),
  cc.find_library('m', required : false),
  valac.find_library ('gio-2.0-workaround', dirs: vapi_dir),
  valac.find_library ('linux'),
  valac.find_library ('posix'),
]

spice = dependency ('spice-client-gtk-3.0', version: '>= 0.32')
if spice.found ()
  vala_args += '--define=HAS_SPICE'
  # FIXME Remove and bump version after libhandy 1.6 is released.
  vala_args += '--disable-since-check'

  dependencies += [
    spice,
    valac.find_library ('spice-client-gtk-3.0')
  ]

  vala_sources += [
    'spice-display.vala',
    'transfer-popover.vala'
  ]
endif

if get_option('rdp')
  vala_sources += ['rdp-display.vala']

  vala_args += '--define=HAVE_RDP'
endif

if get_option('flatpak')
  vala_args += '--define=FLATPAK'

  dependencies += dependency ('govf-0.1')

  if get_option('rdp')
    dependencies += dependency ('gtk-frdp-0.1')
  endif
else
  dependencies += [
    dependency ('gudev-1.0', version: '>= 165'),
  ]

  if get_option('rdp')
    gtk_frdp = subproject(
      'gtk-frdp',
      default_options: [
        'package_subdir=' + meson.project_name()
      ]
    )

    dependencies += gtk_frdp.get_variable('gtk_frdp_vapi')
  endif

  libovf = subproject(
    'libovf-glib',
    default_options: [
      'package_subdir=' + meson.project_name()
    ]
  )

  dependencies += libovf.get_variable('govf_vapi')
endif

executable ('gnome-boxes', vala_sources + resources,
            include_directories: config_h_dir,
            vala_args: vala_args,
            c_args : c_args,
            dependencies: dependencies,
            link_with: libcommon,
            install: true,
            install_rpath: join_paths (get_option ('prefix'), get_option ('libdir'), 'gnome-boxes')
)

executable ('gnome-boxes-search-provider', 'gnome-boxes-search-provider.vala',
            include_directories: config_h_dir,
            vala_args: vala_args,
            c_args: c_args,
            dependencies: common_dependencies,
            link_with: libcommon,
            install: true,
            install_dir: get_option ('libexecdir')
)
