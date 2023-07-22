use eframe::{App, Frame};
use egui::{Context, SidePanel};

use ereactor::{Dispatch, Model, View};

#[derive(Default)]
pub struct AppState {
    pub greeting: String,
}

pub enum AppMsg {
    SetGreeting(String),
}

impl Model for View {
    fn update(&mut self, ctx: &Context, _frame: &mut Frame) {
        SidePanel::left("side_panel").show(ctx, |ui| {
            ui.heading("Hello World");
        });
    }
}

fn main() -> eframe::Result<()> {
    env_logger::init(); // Log to stderr (if you run with `RUST_LOG=debug`).

    let native_options = eframe::NativeOptions::default();
    eframe::run_native(
        "eframe template",
        native_options,
        Box::new(|_| Box::new(SimpleExample::default())),
    )
}
