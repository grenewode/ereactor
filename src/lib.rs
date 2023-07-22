use std::future::Future;

#[cfg(feature = "tokio")]
mod tokio;

pub mod view {
    use crate::Dispatch;

    pub trait View<T: ?Sized> {
        type Message;

        fn render(&self, target: &mut T, dispatch: impl Dispatch<Self::Message>);
    }
}

pub mod model {
    use crate::Dispatch;

    pub trait Model {
        type Message;

        fn reduce<M, D>(
            &mut self,
            messages: impl IntoIterator<Item = Self::Message>,
            dispatch: impl Dispatch<Self::Message>,
        );
    }
}

pub trait Dispatch<T>: Send {
    fn dispatch<F>(&mut self, message: F)
    where
        F: 'static + Send + FnOnce() -> T;

    fn dispatch_async<F>(&mut self, message: F)
    where
        F: 'static + Send + Future<Output = T>;
}

impl<'a, T, U> Dispatch<U> for &'a mut T {
    fn dispatch<F>(&mut self, message: F) {

    }

    fn dispatch_async<F>(&mut self, message: F)
    where
        F: 'static + Send + Future<Output = U> {
        todo!()
    }
}
