#include "ObjectDetection.hpp"

double ObjectDetection::getArea() {
    return areaInfo;
}

cv::Mat ObjectDetection::getImage() {
    return imageInfo;
}

cv::Point ObjectDetection::getCenter() {
    return centerInfo;
}

void ObjectDetection::drawWeightedContour(cv::Mat image, std::vector<cv::Point> contour) {
    cv::Mat mask = cv::Mat::zeros(image.size(), CV_8UC1);
    std::vector<std::vector<cv::Point>> contours = { contour };
    cv::drawContours(mask, contours, -1, cv::Scalar(255), cv::FILLED);

    // Create an opaque version of the original image
    cv::Mat overlayedImage = image.clone();

    // Apply the mask to the overlayed image
    overlayedImage.setTo(contourColor, mask);

    // Blend the overlayed image with the original image
    double alpha = 0.4;
    cv::addWeighted(overlayedImage, alpha, image, 1.0 - alpha, 0, image);
    cv::drawContours(image, contours, -1, contourColor, 1 + ((image.rows + image.cols) / 400));
}

cv::Mat ObjectDetection::getEdges(cv::Mat image) {
    cv::Mat gray;
    cv::cvtColor(image, gray, cv::COLOR_BGR2GRAY);

    cv::Mat blurredImage;
    cv::GaussianBlur(gray, blurredImage, cv::Size(1, 1), 0, 0);

    // Apply Canny edge detection
    cv::Mat edges;
    cv::Canny(blurredImage, edges, 50, 135);

    cv::Mat dilatedEdges;
    cv::dilate(edges, dilatedEdges, cv::Mat(), cv::Point(-1, -1), 2 + ((image.rows + image.cols) / 1500));

    return dilatedEdges;
}

std::vector<std::vector<cv::Point>> ObjectDetection::getContours(cv::Mat& image) {

    cv::Mat gray;
    cv::cvtColor(image, gray, cv::COLOR_BGR2GRAY);

    // Threshold the grayscale image to create a binary mask
    cv::Mat blurredImage;
    cv::GaussianBlur(gray, blurredImage, cv::Size(1, 1), 0, 0);

    // Apply Canny edge detection
    cv::Mat edges;
    cv::Canny(blurredImage, edges, 50, 135);

    // Apply dilation to enhance edges
    cv::Mat dilatedEdges;
    cv::dilate(edges, dilatedEdges, cv::Mat(), cv::Point(-1, -1), 2 + ((image.rows + image.cols) / 1500));

    // Find contours in the mask
    std::vector<std::vector<cv::Point>> contours; 
    cv::findContours(dilatedEdges, contours, cv::RETR_EXTERNAL, cv::CHAIN_APPROX_SIMPLE);

    std::vector<std::vector<cv::Point>> filteredContours;
    int minArea = 2000;

    for (const auto& contour : contours) {
        double area = contourArea(contour);
        if (area >= minArea) {
            filteredContours.push_back(contour);
        }
    }

    return filteredContours;
}

void ObjectDetection::findObjectInfo(cv::Mat image, int x, int y) {
    // Create a point for the specific pixel
    cv::Point point(x, y);

    std::vector<std::vector<cv::Point>> contours = getContours(image);
    double area = 0;
    cv::Point center(0, 0);

    // Check if the specific pixel is within any contour
    for (const auto& contour : contours) {
        if (cv::pointPolygonTest(contour, point, false) >= 0) {

            // Calculate the area
            area = cv::contourArea(contour);

            // Draw the contour containing the specific pixel
            //drawWeightedContour(image, contour);
            cv::drawContours(image, contour, -1, contourColor, 1 + ((image.rows + image.cols) / 400));
            cv::circle(image, point, 5, cv::Scalar(0, 0, 255), -1); // Draw the specific pixel

            // Calculate center
            center = cv::Point(0, 0);
            for (const auto& p : contour) {
                center += p;
            }
            center.x /= contour.size();
            center.y /= contour.size();

            areaInfo = area;
            imageInfo = image;
            centerInfo = center;

            break;
        }
    }
}

void ObjectDetection::centerObjectInfo(cv::Mat image) {

    std::vector<std::vector<cv::Point>> contours = getContours(image);
    double area = 0;
    cv::Point center(0, 0);

    // Calculate centroids of contours
    std::vector<cv::Moments> mu(contours.size());
    for (size_t i = 0; i < contours.size(); i++) {
        mu[i] = cv::moments(contours[i]);
    }

    // Find the contour corresponding to the object in the center
    cv::Point2f imageCenter(static_cast<float>(image.cols / 2), static_cast<float>(image.rows / 2));
    int centerContourIndex = -1;
    float minDist = std::numeric_limits<float>::max();

    for (size_t i = 0; i < contours.size(); i++) {
        cv::Point2f centroid(static_cast<float>(mu[i].m10 / mu[i].m00), static_cast<float>(mu[i].m01 / mu[i].m00));
        float dist = cv::norm(imageCenter - centroid);

        if (dist < minDist) {
            minDist = dist;
            centerContourIndex = static_cast<int>(i);
            center.x = mu[i].m10 / mu[i].m00;
            center.y = mu[i].m01 / mu[i].m00;
            area = cv::contourArea(contours[i]);
        }
    }

    // Draw the contour of the center object onto the image
    drawWeightedContour(image, contours[centerContourIndex]);
    //cv::drawContours(image, contours, centerContourIndex, contourColor, 1 + ((image.rows + image.cols) / 400));

    areaInfo = area;
    imageInfo = image;
    centerInfo = center;
}

cv::Mat ObjectDetection::findObject(cv::Mat image, int x, int y) {

    // Create a point for the specific pixel
    cv::Point point(x, y);

    std::vector<std::vector<cv::Point>> contours = getContours(image);

    // Check if the specific pixel is within any contour
    for (const auto& contour : contours) {
        if (cv::pointPolygonTest(contour, point, false) >= 0) {
            // Draw the contour containing the specific pixel
            drawWeightedContour(image, contour);
            //cv::drawContours(image, contours, -1, contourColor, 1 + ((image.rows + image.cols) / 400));
            cv::circle(image, point, 5, cv::Scalar(0, 0, 255), -1); // Draw the specific pixel
            break;
        }
    }

    return image;
}

int ObjectDetection::findObjectArea(cv::Mat image, int x, int y) {
    // Create a point for the specific pixel
    cv::Point point(x, y);

    std::vector<std::vector<cv::Point>> contours = getContours(image);
    double area = 0;

    // Check if the specific pixel is within any contour
    for (const auto& contour : contours) {
        if (cv::pointPolygonTest(contour, point, false) >= 0) {
            //Find the area of the object
            area = cv::contourArea(contour);

            break;
        }
    }

    return area;
}

int ObjectDetection::identifyCenterObjectArea(cv::Mat image) {

    std::vector<std::vector<cv::Point>> contours = getContours(image);

    // Calculate centroids of contours
    std::vector<cv::Moments> mu(contours.size());
    for (size_t i = 0; i < contours.size(); i++) {
        mu[i] = cv::moments(contours[i]);
    }

    // Find the contour corresponding to the object in the center
    cv::Point2f imageCenter(static_cast<float>(image.cols / 2), static_cast<float>(image.rows / 2));
    int centerContourIndex = -1;
    float minDist = std::numeric_limits<float>::max();

    double area = 0;

    for (size_t i = 0; i < contours.size(); i++) {
        cv::Point2f centroid(static_cast<float>(mu[i].m10 / mu[i].m00), static_cast<float>(mu[i].m01 / mu[i].m00));
        float dist = cv::norm(imageCenter - centroid);

        if (dist < minDist) {
            minDist = dist;
            area = cv::contourArea(contours[i]);
        }
    }

    return area;
}

cv::Mat ObjectDetection::identifyCenterObject(cv::Mat image) {

    std::vector<std::vector<cv::Point>> contours = getContours(image);

    // Calculate centroids of contours
    std::vector<cv::Moments> mu(contours.size());
    for (size_t i = 0; i < contours.size(); i++) {
        mu[i] = cv::moments(contours[i]);
    }

    // Find the contour corresponding to the object in the center
    cv::Point2f imageCenter(static_cast<float>(image.cols / 2), static_cast<float>(image.rows / 2));
    int centerContourIndex = -1;
    float minDist = std::numeric_limits<float>::max();

    double area = 0;

    for (size_t i = 0; i < contours.size(); i++) {
        cv::Point2f centroid(static_cast<float>(mu[i].m10 / mu[i].m00), static_cast<float>(mu[i].m01 / mu[i].m00));
        float dist = cv::norm(imageCenter - centroid);

        if (dist < minDist) {
            minDist = dist;
            centerContourIndex = static_cast<int>(i);
        }
    }

    //Draw the contour of the center object onto the image
    drawWeightedContour(image, contours[centerContourIndex]);

    return image;
}

std::string ObjectDetection::findCenterOfObject(cv::Mat image) {

    std::vector<std::vector<cv::Point>> contours = getContours(image);

    // Calculate centroids of contours
    std::vector<cv::Moments> mu(contours.size());
    for (size_t i = 0; i < contours.size(); i++) {
        mu[i] = cv::moments(contours[i]);
    }

    // Find the contour corresponding to the object closest to the center
    cv::Point2f imageCenter(static_cast<float>(image.cols / 2), static_cast<float>(image.rows / 2));
    int centerContourIndex = -1;
    float minDist = std::numeric_limits<float>::max();

    for (size_t i = 0; i < contours.size(); i++) {
        cv::Point2f centroid(static_cast<float>(mu[i].m10 / mu[i].m00), static_cast<float>(mu[i].m01 / mu[i].m00));
        float dist = cv::norm(imageCenter - centroid);

        if (dist < minDist) {
            minDist = dist;
            centerContourIndex = static_cast<int>(i);
        }
    }

    // Return the centroid of the closest object
    cv::Point2f center;
    if (centerContourIndex != -1) {
        center = cv::Point2f(mu[centerContourIndex].m10 / mu[centerContourIndex].m00, mu[centerContourIndex].m01 / mu[centerContourIndex].m00);
    }
    else {
        center = cv::Point2f(-1, -1); // Return invalid point if no object found
    }

    std::ostringstream oss;
    oss << center.x << ", " << center.y;
    std::string ret = oss.str();

    return ret;
}
