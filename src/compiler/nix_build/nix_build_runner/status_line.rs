//! A one-row status line at the bottom of the terminal.
//!
//! Unlike the `status-line` crate (background redraw thread), this has a single writer: logone owns stderr,
//! so "clear, print the log line, redraw" can't interleave with a redraw. Disabled when stderr isn't a tty.
use std::io::Write;
use std::time::{Duration, Instant};

const PERIOD: Duration = Duration::from_millis(100);
const CLEAR: &str = "\r\x1b[2K";

pub struct StatusLine {
    enabled: bool,
    visible: bool,
    text: String,
    drawn: String,
    last_draw: Instant,
}

impl StatusLine {
    pub fn new(enabled: bool) -> Self {
        StatusLine { enabled, visible: false, text: String::new(), drawn: String::new(), last_draw: Instant::now() }
    }

    pub fn set(&mut self, text: String) {
        self.text = text;
    }

    /// Prints `s` above the status line; the next `refresh` puts the status line back.
    pub fn println(&mut self, s: &str) {
        let mut err = std::io::stderr().lock();
        if self.visible {
            let _ = err.write_all(CLEAR.as_bytes());
            self.visible = false;
        }
        let _ = writeln!(err, "{s}");
    }

    /// Redraws right away if a print hid the line; otherwise changed text is redrawn at most every PERIOD.
    pub fn refresh(&mut self) {
        if !self.enabled || self.text.is_empty() || (self.visible && self.text == self.drawn) {
            return;
        }
        if self.visible && self.last_draw.elapsed() < PERIOD {
            return;
        }
        let mut err = std::io::stderr().lock();
        // `?7l` turns off auto-wrap, so a long line is clipped instead of wrapping into a row we couldn't clear.
        let _ = write!(err, "{CLEAR}\x1b[?7l{}\x1b[?7h", self.text);
        let _ = err.flush();
        self.visible = true;
        self.drawn.clone_from(&self.text);
        self.last_draw = Instant::now();
    }

    pub fn clear(&mut self) {
        self.text.clear();
        if self.visible {
            let _ = std::io::stderr().lock().write_all(CLEAR.as_bytes());
            self.visible = false;
        }
    }
}
