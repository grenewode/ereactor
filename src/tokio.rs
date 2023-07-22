use std::future::{IntoFuture, Future};

use tokio::task::JoinSet;

use crate::Dispatch;

impl<T> Dispatch<T> for JoinSet<T>
where
    T: Send + 'static,
{
    fn dispatch<F>(&mut self, message: F)
    where
        F: 'static + Send + FnOnce() -> T,
    {
        self.spawn_blocking(message);
    }

    fn dispatch_async<F>(&mut self, message: F)
    where
        F: 'static + Send + Future<Output = T>,
    {
        self.spawn(message);
    }
}
