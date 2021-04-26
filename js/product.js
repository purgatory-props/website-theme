function changeBigPictureForProduct(e) {
    var productImageContainer = document.getElementById('productImage');
    if (productImageContainer == null)
        return;

    if (e.target == null || !e.target.hasAttribute('data-image'))
        return;

    productImageContainer.setAttribute('src', e.target.getAttribute('data-image'));

    // Set link to full image
    var productImageLink = document.getElementById('fullImageLink');
    if (e.target.hasAttribute('data-fullImage') && productImageLink != null) {
        productImageLink.setAttribute('href', e.target.getAttribute('data-fullImage'));
    }

    return false;
}
