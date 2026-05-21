<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"  uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!doctype html>
<html lang="en">
<jsp:include page="/WEB-INF/templates/head.jsp">
    <jsp:param name="title"          value="Request / Custom Order — Kathmandu Furniture"/>
    <jsp:param name="pageFolder"     value="user"/>
    <jsp:param name="currentCssFile" value="request"/>
    <jsp:param name="headerCssFile"  value="header"/>
    <jsp:param name="footerCssFile"  value="footer"/>
</jsp:include>
<body>
<jsp:include page="/WEB-INF/templates/user/header.jsp"/>

<div class="req-page">

    <nav class="cat-breadcrumb">
        <a href="${pageContext.request.contextPath}/user/home">Home</a> ›
        <a href="${pageContext.request.contextPath}/user/products">Products</a> ›
        <span>Request / Custom Order</span>
    </nav>

    <%-- Success / Error toast --%>
    <c:if test="${param.submitted == 'true'}">
        <div class="req-toast req-toast-success">
            <i class="fa-solid fa-circle-check"></i>
            Your request has been submitted! Our team will contact you shortly.
        </div>
    </c:if>
    <c:if test="${param.submitted == 'error'}">
        <div class="req-toast req-toast-error">
            <i class="fa-solid fa-circle-exclamation"></i>
            Something went wrong. Please try again.
        </div>
    </c:if>

    <div class="req-layout">

        <%-- Left: Info panel --%>
        <div class="req-info-panel">
            <div class="req-info-icon"><i class="fa-solid fa-pen-ruler"></i></div>
            <h2 class="req-info-title">Can't find what you need?</h2>
            <p class="req-info-desc">
                Submit a request for an out-of-stock item or describe your dream furniture —
                our team will get in touch within 24 hours with a quote and timeline.
            </p>
            <ul class="req-info-list">
                <li><i class="fa-solid fa-check"></i> Out-of-stock product requests</li>
                <li><i class="fa-solid fa-check"></i> Custom size &amp; dimensions</li>
                <li><i class="fa-solid fa-check"></i> Material &amp; design preferences</li>
                <li><i class="fa-solid fa-check"></i> Budget-friendly options</li>
            </ul>
        </div>

        <%-- Right: Form --%>
        <div class="req-form-panel">
            <h1 class="req-form-title">
                <c:choose>
                    <c:when test="${not empty linkedProduct}">
                        Request: <c:out value="${linkedProduct.productName}"/>
                    </c:when>
                    <c:otherwise>Custom Furniture Request</c:otherwise>
                </c:choose>
            </h1>

            <form method="post" action="${pageContext.request.contextPath}/user/request"
                  class="req-form" enctype="multipart/form-data">

                <c:if test="${not empty linkedProduct}">
                    <input type="hidden" name="productId" value="${linkedProduct.id}"/>
                    <div class="req-linked-product">
                        <img src="${pageContext.request.contextPath}/static/images/${fn:escapeXml(linkedProduct.image)}"
                             alt="${fn:escapeXml(linkedProduct.productName)}"
                             onerror="this.style.display='none'"/>
                        <div>
                            <div class="req-linked-name"><c:out value="${linkedProduct.productName}"/></div>
                            <div class="req-linked-cat"><c:out value="${linkedProduct.category}"/></div>
                            <span class="req-linked-badge">
                                <c:out value="${linkedProduct.availability}"/>
                            </span>
                        </div>
                    </div>
                </c:if>

                <div class="req-section-title">Your Contact Details</div>
                <div class="req-row">
                    <div class="req-field">
                        <label>Full Name *</label>
                        <input type="text" name="fullName" required
                               value="${fn:escapeXml(user.firstName)} ${fn:escapeXml(user.lastName)}"
                               placeholder="Your full name"/>
                    </div>
                    <div class="req-field">
                        <label>Phone Number *</label>
                        <input type="text" name="phoneNumber" required
                               value="${fn:escapeXml(user.mobileNumber)}"
                               placeholder="98XXXXXXXX"/>
                    </div>
                </div>
                <div class="req-field">
                    <label>Delivery Location *</label>
                    <input type="text" name="deliveryLocation" required placeholder="Your address / city"/>
                </div>

                <div class="req-section-title" style="margin-top:28px;">Furniture Details</div>
                <div class="req-row">
                    <div class="req-field">
                        <label>Furniture Type *</label>
                        <select name="furnitureType" required>
                            <option value="">Select type...</option>
                            <c:if test="${not empty linkedProduct}">
                                <option value="${fn:escapeXml(linkedProduct.category)}" selected>
                                    <c:out value="${linkedProduct.category}"/>
                                </option>
                            </c:if>
                            <option value="Sofas &amp; Seating">Sofas &amp; Seating</option>
                            <option value="Beds &amp; Mattresses">Beds &amp; Mattresses</option>
                            <option value="Tables &amp; Desks">Tables &amp; Desks</option>
                            <option value="Chairs &amp; Stools">Chairs &amp; Stools</option>
                            <option value="Decor &amp; Rugs">Decor &amp; Rugs</option>
                            <option value="Storage &amp; Cabinets">Storage &amp; Cabinets</option>
                            <option value="Other">Other</option>
                        </select>
                    </div>
                    <div class="req-field">
                        <label>Quantity</label>
                        <input type="number" name="quantity" min="1" max="50" value="1"/>
                    </div>
                </div>
                <div class="req-row">
                    <div class="req-field">
                        <label>Preferred Material</label>
                        <input type="text" name="material" placeholder="e.g. Solid wood, Fabric, Leather..."/>
                    </div>
                    <div class="req-field">
                        <label>Design Style</label>
                        <input type="text" name="design" placeholder="e.g. Modern, Rustic, Minimalist..."/>
                    </div>
                </div>
                <div class="req-row">
                    <div class="req-field">
                        <label>Height (cm)</label>
                        <input type="number" name="height" min="0" step="0.1" placeholder="e.g. 85"/>
                    </div>
                    <div class="req-field">
                        <label>Width (cm)</label>
                        <input type="number" name="width" min="0" step="0.1" placeholder="e.g. 200"/>
                    </div>
                </div>
                <div class="req-field">
                    <label>Purpose / Usage</label>
                    <input type="text" name="purpose" placeholder="e.g. Living room, Office, Bedroom..."/>
                </div>

                <div class="req-section-title" style="margin-top:28px;">Timeline &amp; Budget</div>
                <div class="req-row">
                    <div class="req-field">
                        <label>Budget Range (Rs.)</label>
                        <select name="budgetRange">
                            <option value="">Select range...</option>
                            <option value="Under 10,000">Under Rs. 10,000</option>
                            <option value="10,000 – 30,000">Rs. 10,000 – 30,000</option>
                            <option value="30,000 – 60,000">Rs. 30,000 – 60,000</option>
                            <option value="60,000 – 100,000">Rs. 60,000 – 100,000</option>
                            <option value="Above 100,000">Above Rs. 100,000</option>
                        </select>
                    </div>
                    <div class="req-field">
                        <label>Required By (deadline)</label>
                        <input type="date" name="deadline"/>
                    </div>
                </div>
                <div class="req-field">
                    <label>Installation Required?</label>
                    <div class="req-radio-group">
                        <label class="req-radio"><input type="radio" name="installationRequired" value="Yes"/> Yes</label>
                        <label class="req-radio"><input type="radio" name="installationRequired" value="No" checked/> No</label>
                    </div>
                </div>
                <div class="req-field">
                    <label>Additional Notes</label>
                    <textarea name="notes" rows="4" placeholder="Any other details, references, or special requirements..."></textarea>
                </div>
                <div class="req-field">
                    <label>Reference Image <span style="font-weight:400;color:#9ca3af;">(optional — jpg, png, webp, max 5 MB)</span></label>
                    <div class="req-upload-box" id="reqUploadBox">
                        <i class="fa-solid fa-cloud-arrow-up req-upload-icon"></i>
                        <p class="req-upload-hint">Click to upload or drag &amp; drop</p>
                        <p class="req-upload-name" id="reqFileName">No file chosen</p>
                        <input type="file" name="referenceImage" id="referenceImage"
                               accept=".jpg,.jpeg,.png,.webp" class="req-upload-input"/>
                    </div>
                    <div class="req-upload-preview" id="reqPreviewWrap" style="display:none;">
                        <img id="reqPreviewImg" src="" alt="Preview" class="req-preview-img"/>
                        <button type="button" class="req-remove-img" onclick="removeImage()">
                            <i class="fa-solid fa-xmark"></i> Remove
                        </button>
                    </div>
                </div>

                <button type="submit" class="req-submit-btn">
                    <i class="fa-solid fa-paper-plane"></i> Submit Request
                </button>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/templates/user/footer.jsp"/>
<script>
    const fileInput   = document.getElementById('referenceImage');
    const uploadBox   = document.getElementById('reqUploadBox');
    const fileName    = document.getElementById('reqFileName');
    const previewWrap = document.getElementById('reqPreviewWrap');
    const previewImg  = document.getElementById('reqPreviewImg');

    uploadBox.addEventListener('click', () => fileInput.click());

    uploadBox.addEventListener('dragover', e => { e.preventDefault(); uploadBox.classList.add('drag-over'); });
    uploadBox.addEventListener('dragleave', ()  => uploadBox.classList.remove('drag-over'));
    uploadBox.addEventListener('drop', e => {
        e.preventDefault();
        uploadBox.classList.remove('drag-over');
        if (e.dataTransfer.files.length) {
            fileInput.files = e.dataTransfer.files;
            showPreview(e.dataTransfer.files[0]);
        }
    });

    fileInput.addEventListener('change', () => {
        if (fileInput.files.length) showPreview(fileInput.files[0]);
    });

    function showPreview(file) {
        fileName.textContent = file.name;
        const reader = new FileReader();
        reader.onload = e => {
            previewImg.src = e.target.result;
            uploadBox.style.display = 'none';
            previewWrap.style.display = 'flex';
        };
        reader.readAsDataURL(file);
    }

    function removeImage() {
        fileInput.value = '';
        previewImg.src = '';
        fileName.textContent = 'No file chosen';
        previewWrap.style.display = 'none';
        uploadBox.style.display = 'flex';
    }
</script>
</body>
</html>
