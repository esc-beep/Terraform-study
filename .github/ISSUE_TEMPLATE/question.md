name: ❓ Question / Discussion
description: 학습 중 생긴 질문이나 토론하고 싶은 주제 기록
title: "[Question] {짧은 요약}"
labels: ["question", "discussion"]
body:
  - type: textarea
    id: context
    attributes:
      label: 질문 배경
      description: 어떤 상황에서 이 질문이 생겼나요?
      placeholder: 예: terraform plan 실행 중 output이 예상과 다름
    validations:
      required: true

  - type: textarea
    id: question
    attributes:
      label: 구체적인 질문
      description: 정확히 어떤 점이 궁금한가요?
      placeholder: 예: output 값이 왜 숫자가 아니라 문자열로 나오나요?
    validations:
      required: true

  - type: textarea
    id: tried
    attributes:
      label: 시도해 본 것
      description: 직접 찾아보거나 실험해 본 것이 있나요?
      placeholder: 예: 공식 문서 확인, terraform console 사용
    validations:
      required: false

  - type: textarea
    id: expected
    attributes:
      label: 기대하는 답변/토론 방향
      description: 원하는 답변 방향이나 함께 토론하고 싶은 주제를 적어주세요.
      placeholder: 예: Terraform 변수 타입 처리 방식에 대한 이해
