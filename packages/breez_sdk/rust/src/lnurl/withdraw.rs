use crate::LnUrlWithdrawRequestData;

/// <https://github.com/lnurl/luds/blob/luds/03.md>
pub(crate) async fn validate_lnurl_pay(
    user_amount_sat: u64,
    comment: Option<String>,
    req_data: LnUrlWithdrawRequestData,
) {
}

pub(crate) mod model {}

#[cfg(test)]
mod tests {}
