// This file is part of GNOME Boxes. License: LGPLv2+
using Gtk;

private class Boxes.FrdpDisplay: Frdp.Display {
}

private class Boxes.RdpDisplay: Boxes.Display {
    public override string protocol { get { return "RDP"; } }
    public override string? uri { owned get { return @"rdp://$host:$port"; } }
    private FrdpDisplay display;
    private string host;
    private int port;
    private BoxConfig.SavedProperty[] saved_properties;

    construct {
        saved_properties = {
            BoxConfig.SavedProperty () { name = "read-only", default_value = false }
        };
        display = new FrdpDisplay ();

        display.rdp_connected.connect (() => {
            show (0);
            access_start ();
        });
        display.rdp_disconnected.connect (() => {
            hide (0);
            access_finish ();

            disconnected (true);
        });
    }

    public RdpDisplay (BoxConfig config, string host, int port) {
        this.config = config;

        this.host = host;
        this.port = port;

        config.save_properties (display, saved_properties);
    }

    public RdpDisplay.with_uri (BoxConfig config, string _uri) throws Boxes.Error {
        this.config = config;

        var uri = Xml.URI.parse (_uri);

        if (uri.scheme != "rdp")
            throw new Boxes.Error.INVALID ("the URL is not rdp://");

        if (uri.server == null)
            throw new Boxes.Error.INVALID ("the URL is missing a server");

        this.host = uri.server;
        this.port = uri.port <= 0 ? 3389 : uri.port;

        config.save_properties (display, saved_properties);
    }

    public override Gtk.Widget get_display (int n) {
        return display;
    }

    public override void set_enable_audio (bool enable) {
    }

    public override Gdk.Pixbuf? get_pixbuf (int n) throws Boxes.Error {
        return display.get_pixbuf ();
    }

    public override void connect_it (owned Display.OpenFDFunc? open_fd = null) throws GLib.Error {
        // We only initiate connection once
        if (connected)
            return;
        connected = true;

        display.open_host (host, port);
    }

    public override void disconnect_it () {
        if (display.is_open ())
            display.close ();
    }

    public override void send_keys (uint[] keyvals) {
    }
}
